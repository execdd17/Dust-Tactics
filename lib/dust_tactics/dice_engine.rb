module DustTactics
  module DiceEngine
    
    def self.roll(num_dice)
      results = {:hits => 0, :misses => 0}
      
      num_dice.times do 
        case rand(1..6)
        when 1,2      then results[:hits]   += 1
        when 3,4,5,6  then results[:misses] += 1
        end
      end

      results
    end

  end
end
