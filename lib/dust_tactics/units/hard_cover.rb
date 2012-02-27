module DustTactics
  module Units
    class HardCover < DustTactics::Unit

      STARTING_HIT_POINTS = 4
      TYPE      = :vehicle
      ARMOR     = 5
      MOVEMENT  = 0
      
      def initialize
        super(STARTING_HIT_POINTS, TYPE, ARMOR, MOVEMENT)
      end

      def cover?
        true
      end

    end
  end
end
