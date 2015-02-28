module DustTactics::Units
  class SoftCover < DustTactics::Unit
    include DustTactics::Utils::NamespaceStripper

    STARTING_HIT_POINTS = 2
    TYPE      = :vehicle
    ARMOR     = 3
    MOVEMENT  = 0
    ARMY_POINT= 0
    
    def initialize
      super(STARTING_HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

    def cover?
      true
    end

  end
end
