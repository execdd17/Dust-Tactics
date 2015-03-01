module DustTactics::Units
  class HardCover < DustTactics::Unit
    include DustTactics::Utils::NamespaceStripper

    STARTING_HIT_POINTS = 4
    TYPE      = :vehicle
    ARMOR     = 5
    MOVEMENT  = 0
    ARMY_POINT= 0
    
    def initialize
      super(STARTING_HIT_POINTS, TYPE, ARMOR, MOVEMENT, ARMY_POINT)
    end

    def cover?
      true
    end

    def to_s
      demodulize
    end
  end
end
