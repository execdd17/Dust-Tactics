require 'spec_helper'
include DustTactics

describe DustTactics::Board do
  
  BOARD_ROWS, BOARD_COLUMNS = 4, 4

  before(:each) do 
    @board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
  end

  it "should be made up of spaces" do
    @board.grid.all? { |space| Space === space }.should == true
  end
end

describe DustTactics::Space do

end

describe DustTactics::Unit do

end
