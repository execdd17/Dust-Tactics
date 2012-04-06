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

      # deduct the right tick amount for every state chage
      after_transition any => any - :end, :do => :deduct_ticks

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
      @ticks = 2
      @name, @team, @units, @board = name, team, [], board
      super()
    end

    def deduct_ticks
      @ticks = [@ticks - tick_cost, 0].max
    end

    def add_unit(unit)
      @units << unit
    end

    def remove_unit(unit)
      @units.delete(unit)
      @units
    end
    
    def deploy_unit(unit, end_space)
      movement_helper(unit) do
        unit.deploy(end_space)
      end
    end
    
    def move_unit(unit, end_space)
      movement_helper(unit) do
        raise BusyHands, "Only Interactables Can Move" unless unit.respond_to?(:move)
        unit.move(end_space)
      end
    end

    def movement_helper(unit)
      raise BusyHands, "#{unit} isn't part of my team" unless @units.index(unit)
      raise BigSpender, "Not Enough Ticks!" unless self.more_ticks?

      self.move
      yield
    end

    def attack_unit(attacker_unit, target_unit, weapon_lines)
      raise BigSpender, "Not Enough Ticks!" unless self.more_ticks?
      
      self.attack
      attacker_unit.attack(@board, target_unit, weapon_lines)
    end

    def skip_action
      raise BigSpender, "Not Enough Ticks!" unless self.more_ticks?

      self.do_nothing
    end

    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
    end

  end
end
