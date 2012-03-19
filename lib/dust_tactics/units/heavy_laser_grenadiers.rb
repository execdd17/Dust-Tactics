require 'unit'

module DustTactics::Units
  class HeavyLaserGrenadiers < DustTactics::Unit
    include DustTactics::Weapons
    include DustTactics::Interactable

    HIT_POINTS, ARMOR, MOVEMENT, ARMY_POINT = 3, 3, 1, 30
    TYPE = :infantry

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [SchwerLaserWerfer.new, CombatKnife.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

  end
end
