module DustTactics

  class BusyHands < Exception; end

  class Player

    attr_reader :name, :team, :units, :board

    def initialize(name, team, board)
      @name, @team, @units, @board = name, team, [], board
    end

    def add_unit(unit)
      @units << unit
    end

    def remove_unit(unit)
      @units.delete(unit)
      @units
    end

    def move_unit(unit, end_space)
      raise BusyHands, "#{unit} isn't part of my team" unless @units.index(unit)
      unit.move(end_space)
    end

    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
    end

  end
end
