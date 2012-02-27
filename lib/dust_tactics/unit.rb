module DustTactics
  class Unit

    attr_reader :hit_points, :type, :armor, :movement

    def initialize(hit_points, type, armor, movement)
      @hit_points, @type, @armor, @movement = hit_points, type, armor, movement
    end

    def take_damage(amount)
      @hit_points -= amount
    end
  end
end
