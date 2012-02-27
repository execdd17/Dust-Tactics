module DustTactics
  class Unit

    attr_reader :hit_points, :type, :armor, :movement
    attr_reader :army_point, :space

    def initialize(hit_points, type, armor, movement, army_point)
      @hit_points, @type, @armor, = hit_points, type, armor
      @movement, @army_point = movement, army_point
    end

    def take_damage(amount)
      @hit_points -= amount
    end

    def occupy(space)
      @space = space
      space.occupy(self)
    end

    def in_space?
      @space ? true : false
    end

    # default value for a unit, override in the subclass if its a cover unit
    def cover?
      false
    end

  end
end
