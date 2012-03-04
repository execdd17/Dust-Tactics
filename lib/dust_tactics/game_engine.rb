class CoverSaveException < Exception; end

module DustTactics
  class GameEngine

    # Used to determine who gets to place cover first and who starts the round
    def self.initiative(player_one, player_two)
      begin
        p1_results = DiceEngine.roll(3)  
        p2_results = DiceEngine.roll(3)
      end while p1_results[:hits] == p2_results[:hits]  #ties are lame

      p1_results[:hits] > p2_results[:hits] ? player_one : player_two
    end
  
    def self.resolve_attack(num_rolls, save_type)
      raw_hits    = DiceEngine.roll(num_rolls)[:hits]
      cover_saves = cover_saves(save_type, raw_hits)
      
      { 
        :num_rolls    => num_rolls,
        :save_type    => save_type,
        :raw_hits     => raw_hits, 
        :hit_ratio    => (raw_hits.to_f / num_rolls).round(4),
        :cover_saves  => cover_saves,
        :net_hits     => [raw_hits - cover_saves, 0].max
      }
    end

    # Takes a save_type of either :hit or :miss and the number of
    # unmitigated hits to see whether any damage is negated.
    # Returns the number of cover saves
    def self.cover_saves(save_type, raw_hits)
      case save_type
      when :hit   then DiceEngine.roll(raw_hits)[:hits]
      when :miss  then DiceEngine.roll(raw_hits)[:misses]
      when :none  then 0
      else
        raise CoverSaveException, "Invalid save_type [#{save_type}]"
      end
    end
  end
end
