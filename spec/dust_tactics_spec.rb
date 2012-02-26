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

  it "should have the row dimemson specified above" do
    @board.grid.length.should == BOARD_ROWS
  end
  
  it "should have the column dimemson specified above" do
    @board.grid.all? { |col| col.length == BOARD_COLUMNS }.should == true
  end

  it "should calculate all four neighbors of a point" do
    @board.get_neighbors(1,1).should == [ [0,1], [2,1], [1,0], [1,2] ]
  end
  
  it "should calculate 3 neighbors of a point when one is invalid" do
    @board.get_neighbors(0,2).should == [ [1,2], [0,1], [0,3] ]
  end
  
  it "should calculate 2 neighbors of a point when two are invalid" do
    @board.get_neighbors(3,3).should == [ [2,3], [3,2 ] ]
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
