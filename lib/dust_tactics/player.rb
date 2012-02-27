module DustTactics
  class Player

    attr_reader :name, :team, :units

    def initialize(name, team)
      @name, @team, @units = name, team, []
    end

    def add_unit(unit)
      @units << unit
    end

    def total_ap
      @units.inject(0) { |memo, unit| memo += unit.army_point }
    end

  end
end
