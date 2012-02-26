require 'spec_helper'
include DustTactics

describe DustTactics::Board do
  
  BOARD_ROWS, BOARD_COLUMNS = 4, 4

  before(:each) do 
    @board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
  end

  it "should be a 2d array made up of spaces" do
    @board.grid.all? do |row| 
      row.all? { |space| Space === space }
    end.should == true
  end

  it "should calculate the shortest path between two points" do
    @board.shortest_path([0,0], [0,3]).should ==
      [ [0,0], [0,1], [0,2], [0,3] ]
  end
end

describe DustTactics::Space do

end

describe DustTactics::Unit do

end
