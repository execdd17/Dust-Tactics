require 'state_machine'

class Turn

  # ticks is loosely a type of currency for changing states
  attr_accessor :ticks

  state_machine :state, :initial => :start do

    # deduct the right tick amount for every state chage
    after_transition any => any - :end, :do => :deduct_ticks

    after_transition any => any - :end do |turn, transition|
      turn.finish_turn unless turn.more_ticks?
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

  def initialize
    @ticks = 2
    super()
  end

  def deduct_ticks
    @ticks = [@ticks - tick_cost, 0].max
  end
    
end
