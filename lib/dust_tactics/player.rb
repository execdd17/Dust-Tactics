module DustTactics
  class Player

    attr_reader :name, :team, :units, :board

    def initialize(name, team, board)
      @name, @team, @units, @board = name, team, [], board
    end

    def add_unit(unit)
      @units << unit
    end

    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
    end

  end
end
