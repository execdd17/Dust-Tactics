module DustTactics::Units
  class Rhino < DustTactics::Unit
    include DustTactics::Weapons
    include DustTactics::Interactable
    include DustTactics::Utils::NamespaceStripper

    HIT_POINTS, ARMOR, MOVEMENT, ARMY_POINT = 4, 3, 2, 22
    TYPE = :infantry

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [HeavyRocketPunch.new, HeavyRocketPunch.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

  end
end
