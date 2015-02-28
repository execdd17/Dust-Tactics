module DustTactics::Units
  class Lara < DustTactics::Unit
    include DustTactics::Weapons
    include DustTactics::Interactable
    include DustTactics::Utils::NamespaceStripper

    HIT_POINTS, ARMOR, MOVEMENT, ARMY_POINT = 4, 3, 1, 21
    TYPE = :infantry

    attr_reader :weapon_lines
  
    def initialize
      @weapon_lines = [MG44Zwei.new, MG44Zwei.new, CombatKnife.new]
      super(HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

  end
end
