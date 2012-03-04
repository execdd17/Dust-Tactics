module DustTactics
  class WeaponLine
    attr_reader :name, :type, :combat_values

    # The type can be an integer range such as 1-6; combat values should
    # be in this format: 
    # { :infantry => {1 => "3/4", ...}, :vehicle => {...}, :aircraft => {...}} 
    def initialize(name, type, combat_values)
      @name, @type, @combat_values = name, type, combat_values
    end

    def num_dice(enemy_type, armor_rating)
      cv = get_combat_value(enemy_type, armor_rating)
      cv == "-" ? 0 : cv.split('/').first.to_i
    end

    def get_combat_value(enemy_type, armor_rating)
      @combat_values[enemy_type][armor_rating]
    end
    
    def close_combat?
      type == 'C'
    end
  end
end
