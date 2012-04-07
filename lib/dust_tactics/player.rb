require 'state_machine'

module DustTactics

  class BusyHands     < Exception; end
  class InvalidAction < Exception; end
  class BigSpender    < Exception; end

  class Player
  
    # ticks is loosely a type of currency for changing states
    attr_accessor :ticks
      
    attr_reader :name, :team, :units, :board

    state_machine :state, :initial => :start do
      
      after_transition :end => :start,                :do => :reset_ticks
      after_transition any  => any - [:end, :start],  :do => :deduct_ticks

      after_transition any => any - :end do |player, transition|
        player.finish_turn unless player.more_ticks?
      end

      event :move do
        transition [:start, :moved, :attacked, :did_nothing] => :moved
      end

      event :attack do
        transition [:start, :did_nothing, :moved] => :attacked
      end

      event :do_nothing do
        transition [:start, :did_nothing, :moved, :attacked] => :did_nothing
      end

      event :sustained_attack do
        transition [:start] => :performed_sustained_attack
      end

      event :finish_turn do
        transition all - [:start] => :end
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
    
    def activate_unit(unit)
      raise BusyHands, "#{unit} isn't part of my team" unless @units.include?(unit)
      raise BusyHands, "Only interactables can be activated" unless 
        unit.kind_of?(Interactable)
      
      @unit_this_round = unit
      unit.activate
    end
        
    #TODO: Make sure this only is used in the beginning of a game
    # Another object will likely manage that
    def deploy_cover(cover_unit, space)
      raise BusyHands, "#{cover_unit} isn't part of my team" unless 
        @units.include?(cover_unit)
      
      cover_unit.deploy(space)
      @units.delete(cover_unit) # it's unncessary to keep track of this
    end
    
    def deploy_unit(space)
      action_helper do
        self.move
        @unit_this_round.deploy(space)
      end
    end
    
    def move_unit(space)
      action_helper do
        self.move
        @unit_this_round.move(space)
      end
    end

    #TODO: Since the attacking unit is fixed based on who is activated.
    # I need a way to ensure that arbitrary weapon lines aren't passed
    def attack_unit(target_unit, weapon_lines)
      action_helper do
        self.attack
        @unit_this_round.attack(@board, target_unit, weapon_lines)
      end
    end

    def skip_action
      action_helper { self.do_nothing }
    end

    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
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
      yield
    end
  end
end
