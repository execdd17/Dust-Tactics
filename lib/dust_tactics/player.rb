require 'state_machine'

module DustTactics

  class BusyHands     < Exception; end
  class InvalidAction < Exception; end
  class BigSpender    < Exception; end

  class Player
  
    # ticks is loosely a type of currency for changing states
    attr_reader :name, :team, :units, :board, :ticks

    state_machine :state, :initial => :start do
      
      before_transition :on => :activate,         :do => :activate_unit
      before_transition :on => :move,             :do => :move_unit
      before_transition :on => :do_nothing,       :do => :skip_action
      before_transition :on => :attack,           :do => :attack_unit
      before_transition :on => :sustained_attack, :do => :sustained_attack_unit
      # before_transition :on => :deploy,           :do => :deploy_unit
      
      after_transition any  => any - [:end, :start, :activated], :do => :deduct_ticks
      after_transition :end => :start, :do => :reset_ticks

      after_transition any => any - :end do |player, transition|
        player.finish_turn unless player.more_ticks?
      end

      event :activate do
        transition [:start] => :activated
      end

      event :move do
        transition [:activated, :moved, :attacked, :did_nothing] => :moved
      end

      # event :deploy do
      #   transition [:activated] => :moved
      # end

      event :attack do
        transition [:activated, :did_nothing, :moved] => :attacked
      end

      event :do_nothing do
        transition [:activated, :did_nothing, :moved, :attacked] => :did_nothing
      end

      event :sustained_attack do
        transition [:activated] => :performed_sustained_attack
      end

      event :finish_turn do
        transition [:attacked, :moved, :performed_sustatined_attack, :did_nothing] => :end
      end

      event :restart do
        transition [:end] => :start
      end

      state :attacked, :moved, :did_nothing do
        def tick_cost
          1
        end
      end

      state :performed_sustained_attack do
        def tick_cost
          2
        end
      end

      state all do
        def more_ticks?
          @ticks > 0
        end
      end
    end

    def initialize(name, team, board)
      @ticks = @orig_ticks = 2
      @name, @team, @units, @board = name, team, [], board
      super()
    end

    def add_unit(unit)
      @units << unit
    end

    def remove_unit(unit)
      @units.delete(unit)
      @units
    end
    
    # #TODO: Make sure this only is used in the beginning of a game
    # # Another object will likely manage that
    # def deploy_cover(cover_unit, space)
    #   raise BusyHands, "#{cover_unit} isn't part of my team" unless
    #     @units.include?(cover_unit)
    #
    #   cover_unit.deploy(space)
    #   @units.delete(cover_unit) # it's unncessary to keep track of this
    # end
    #
    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
    end

    def activatable_units
      @units.select { |unit| !unit.activated? && unit.alive? }
    end

    def has_activatable_units?
      activatable_units > 0
    end

    def reset_round
      puts "#{name} is calling reset round"
      @units.each { |unit| unit.deactivate }
    end

    def all_units_dead?
      @units.none? { |unit| unit.alive? }
    end

    def self.move_cover(cover_unit, space)
      cover_unit.space
    end

    private

    def reset_ticks
      @ticks = @orig_ticks
    end

    def deduct_ticks
      @ticks = [@ticks - tick_cost, 0].max
    end

    def action_helper
      raise BusyHands, "A unit has not been activated yet" unless @unit_this_round
      raise BigSpender, "Not Enough Ticks!" unless self.more_ticks?
      yield if block_given?
    end
        
    def activate_unit(transition)
      unit = transition.args.first
      raise BusyHands, "#{unit} isn't part of my team" unless @units.include?(unit)
      raise BusyHands, "Only interactables can be activated" unless 
        unit.kind_of?(Interactable)
      
      @unit_this_round = unit
      @unit_this_round.activate
    end

    def sustained_attack_unit(transition)
      raise 'Not Implemented yet'
    end
        
    def attack_unit(transition)
      target_unit, weapon_lines = transition.args
      action_helper do
        ap @unit_this_round.attack(@board, target_unit, weapon_lines)
      end
    end

    # def deploy_unit(transition)
    #   space = transition.args.first
    #   action_helper { @unit_this_round.deploy(space) }
    # end
        
    def move_unit(transition)
      space = transition.args.first
      action_helper { @unit_this_round.move(space) }
    end
    
    def skip_action(transition)
      action_helper 
    end
  end
end
