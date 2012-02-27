module DustTactics
  class Unit

    attr_reader :hit_points, :armor, :movement

    def initialize(hit_points, armor, movement)
      @hit_points, @armor, @movement = hit_points, armor, movement
    end

    def take_damage(amount)
      @hit_points -= amount
    end
  end
end
