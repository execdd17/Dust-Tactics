class CoverSaveException < Exception; end

module DustTactics
  module GameEngine

    # Used to determine who gets to place cover first and who starts the round
    def self.initiative(player_one, player_two)
      begin
        p1_results = DiceEngine.roll(3)  
        p2_results = DiceEngine.roll(3)
      end while p1_results[:hits] == p2_results[:hits]  #ties are lame

      p1_results[:hits] > p2_results[:hits] ? player_one : player_two
    end

    # Returns an array of size two with the winner of the roll at index 0
    # TODO: how is this any better than GameEngine.initiative() ?
    def self.initiative_as_list(player_one, player_two)
      winner = GameEngine.initiative(player_one, player_two)
      [winner] + ([player_one, player_two] - [winner])
    end
  
    # This deals primarily with rolling dice and returning a nice report
    def self.resolve_attack(num_rolls, save_type)
      raw_hits    = DiceEngine.roll(num_rolls)[:hits]
      cover_saves = cover_saves(save_type, raw_hits)
      
      { 
        :num_rolls    => num_rolls,
        :save_type    => save_type,
        :raw_hits     => raw_hits, 
        :hit_ratio    => (raw_hits.to_f / num_rolls).round(2),
        :cover_saves  => cover_saves,
        :net_hits     => [raw_hits - cover_saves, 0].max
      }
    end
  
    # Updates a battle report to reflect the individual player report given
    # their side. For example, a unit attacks with two weapon lines and
    # calls this method to aggregate the two attacks into one battle report
    
    # NOTE: This method will simply merge the two reports together if
    # battle_report[side] doesn't exist already
    def self.combine_reports(battle_report, player_report, side)
      unless battle_report[side] then
        return battle_report.merge(side => player_report) 
      end

      updates = battle_report[side].inject( {side => Hash.new} ) do |memo, tuple|
        key = tuple.first

        case key
        when :num_rolls, :raw_hits, :cover_saves, :net_hits then 
          memo[side][key] = battle_report[side][key] += player_report[key]
        when :hit_ratio   then 
          new_ratio = (battle_report[side][key].to_f + player_report[key]) / 2
          memo[side][key] = new_ratio.round(2)
        when :save_type   then memo[side][key] = battle_report[side][key]
        end
        
        memo
      end

      battle_report.merge(updates)
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
