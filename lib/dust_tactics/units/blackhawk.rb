module DustTactics::Units
  class Blackhawk < DustTactics::Unit
    include DustTactics::Weapons
    include DustTactics::Interactable
    include DustTactics::Utils::NamespaceStripper

    HIT_POINTS, ARMOR, MOVEMENT, ARMY_POINT = 3, 3, 1, 22
    TYPE = :vehicle

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [DualHeavyPIAT.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

    def to_s
      "#{demodulize}:#{hit_points}HP"
    end
  end
end
