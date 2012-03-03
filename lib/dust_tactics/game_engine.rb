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
  end
end
