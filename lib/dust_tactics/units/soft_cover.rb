module DustTactics
  module Units
    class SoftCover < DustTactics::Unit

      STARTING_HIT_POINTS = 2
      TYPE      = :vehicle
      ARMOR     = 3
      MOVEMENT  = 0
      
      def initialize
        super(STARTING_HIT_POINTS, TYPE, ARMOR, MOVEMENT)
      end

    end
  end
end
