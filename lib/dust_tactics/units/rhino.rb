require 'unit'

module DustTactics::Units
  class Rhino < DustTactics::Unit
    include DustTactics::Weapons

    HIT_POINTS, TYPE, ARMOR, MOVEMENT = 4, :infantry, 3, 2

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [HeavyRocketPunch.new, HeavyRocketPunch.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT)
    end

  end
end
