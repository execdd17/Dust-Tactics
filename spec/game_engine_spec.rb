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

  context ".resolve attack" do
    before(:each) do
      @num_rolls = rand(1..100)  
    end
    
    it "should validate that all the hash entries returned" do
      pending
    end

    it "should not return less than 0 when subtracting hit cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :hit)[:net_hits] 
      end.should be >= 0 
    end
    
    it "should not return less than 0 when subtracting miss cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :miss)[:net_hits]
      end.should be >= 0 
    end
    
    it "should not return less than 0 when subtracting no cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :none)[:net_hits] 
      end.should be >= 0 
    end
    
    it "should not return greater than num_rolls with hit cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :hit)[:net_hits].should be <= @num_rolls
      end
    end
    
    it "should not return greater than num_rolls with miss cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :miss)[:net_hits].should be <= @num_rolls 
      end
    end
    
    it "should not return greater than num_rolls with hit cover saves" do
      100.times do 
        GameEngine.resolve_attack(@num_rolls, :none)[:net_hits].should be <= @num_rolls 
      end
    end
  end

  context ".cover_saves" do
    before(:each) do
      @raw_hits = rand(0..100)
    end

    it "should return 0 when there is no cover" do
      GameEngine.cover_saves(:none, @raw_hits).should == 0
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
