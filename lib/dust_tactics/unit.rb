# Raised when trying to use Unit#deploy more than once
class InvalidDeployment < Exception; end

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

    # deploys the unit to a space
    # NOTE: This should only be used for deployment! After that,
    # a unit that mixed in Interactable should use move()
    def deploy(space)
      if @space then
        raise InvalidDeployment,
          "Unit already occupies a space, use move() instead" 
      elsif not space
        raise InvalidDeployment, "Deployment Space Invalid"
      end

      @space = space
      space.occupy(self)
    end

    def alive?
      @hit_points > 0
    end

    # check if self has line of sight to the supplied unit
    # TODO: Create blocked spaces and actually use this
    def los?(unit)
      true  
    end

    def in_space?
      @space ? true : false
    end

    # default value for a unit, override in the subclass if its a cover unit
    def cover?
      false
    end

    def get_save_type
      if Units::HardCover === space.cover then
        :miss
      elsif Units::SoftCover === space.cover then
        :hit
      else
        :none
      end
    end

  end
end
