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

  it "should return an empty hash when the end point greater then the board's row size" do
    @board.get_distance_hash( [0,0], [BOARD_ROWS,0] ).should == {}
  end
  
  it "should return an empty hash when the end point greater then the board's row size" do
    @board.get_distance_hash( [0,0], [0,BOARD_COLUMNS] ).should == {}
  end
  
  it "should return an empty hash when the end point greater then the board's row size and column size" do
    @board.get_distance_hash( [0,0], [BOARD_ROWS,BOARD_COLUMNS] ).should == {}
  end

  it "should assign a distance value to all points 0 away" do
    correct_result = { 0 => [[0,0]] }
    @board.get_distance_hash( [0,0], [0,0]).should == correct_result
  end

  it "should assign a distance value to all points between 0 and 1 away" do
    correct_result = { 0 => [[0,0]], 1 => [ [1,0], [0,1] ] }
    @board.get_distance_hash( [0,0], [0,1]).should == correct_result
  end
  
  it "should assign a distance value to all points between 0 and 2 away" do
    correct_result =  { 0 => [ [0,0] ], 
                        1 => [ [1,0], [0,1] ],
                        2 => [ [2,0], [1,1], [0,2]] }
    
    @board.get_distance_hash( [0,0], [0,2]).should == correct_result
  end
  
  it "should determine when the upper point is adjacent" do
    @board.adjacent?( [2,2], [1,2] ).should == true
  end
  
  it "should determine when the lower point is adjacent" do
    @board.adjacent?( [2,2], [3,2] ).should == true
  end

  it "should determine when the left point is adjacent" do
    @board.adjacent?( [2,2], [2,1] ).should == true
  end
  
  it "should determine when the right point is adjacent" do
    @board.adjacent?( [2,2], [2,3] ).should == true
  end

  it "should determine that the bottem left diagonal is not adjacent" do
    @board.adjacent?( [2,2], [3,1] ).should == false
  end
  
  it "should determine that the top left diagonal is not adjacent" do
    @board.adjacent?( [2,2], [1,1] ).should == false
  end

  it "should determine that the bottem right diagonal is not adjacent" do
    @board.adjacent?( [2,2], [3,3] ).should == false
  end

  it "should determine that the top right diagonal is not adjacent" do
    @board.adjacent?( [2,2], [1,3] ).should == false
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
