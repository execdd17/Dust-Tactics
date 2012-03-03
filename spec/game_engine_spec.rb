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


end
