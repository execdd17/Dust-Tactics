require 'unit'

module DustTactics::Units
  class BlackHawk < DustTactics::Unit
    include DustTactics::Weapons
    include DustTactics::Interactable

    HIT_POINTS, ARMOR, MOVEMENT, ARMY_POINT = 3, 3, 1, 22
    TYPE = :vehicle

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [DualHeavyPIAT.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

  end
end
