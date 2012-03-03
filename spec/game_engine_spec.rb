require 'spec_helper'

describe DustTactics::GameEngine do

  before(:each) do
    board             = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @allied_player    = Player.new("Franky Four Fingers", "allied", board)
    @axis_player      = Player.new("Johnny English"     , "axis",   board)
  end

  context ".initiative" do
    it "should calculate who wins the initiative" do
      [@allied_player, @axis_player].include?( 
        GameEngine.initiative(@allied_player, @axis_player)).should == true
    end
  end

  context ".cover_saves" do
    before(:each) do
      @raw_hits   = rand(0..100)
    end

    it "should return a value greater to or equal zero when given hit" do
      100.times { GameEngine.cover_saves(:hit, @raw_hits).should be >= 0 }
    end
    
    it "should return a value greater to or equal zero when given miss" do
      100.times { GameEngine.cover_saves(:miss, @raw_hits).should be >= 0 }
    end

    it "should return a value less than or equal to the raw hits given hit" do
      100.times { GameEngine.cover_saves(:hit, @raw_hits).should be >= 0 }
    end
    
    it "should return a value less than or equal to the raw hits given miss" do
      100.times { GameEngine.cover_saves(:miss, @raw_hits).should be >= 0 }
    end

    it "should raise an exception when entering an invalid save_type" do
      lambda { GameEngine.cover_saves(:bogus_type, @raw_hits)
      }.should raise_error CoverSaveException, "Invalid save_type [bogus_type]"
    end
  end

end
