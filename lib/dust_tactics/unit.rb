module DustTactics
  class Unit

    attr_reader :hit_points, :type, :armor, :movement

    def initialize(hit_points, type, armor, movement)
      @hit_points, @type, @armor, @movement = hit_points, type, armor, movement
    end

    def take_damage(amount)
      @hit_points -= amount
    end

    # default value for a unit, override in the subclass if its a cover unit
    def cover?
      false
    end

  end
end
