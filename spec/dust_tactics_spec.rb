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

  context "#get_neighbors" do
    it "should calculate all four neighbors of a point" do
      @board.get_neighbors(1,1).should == [ [0,1], [2,1], [1,0], [1,2] ]
    end

    it "should calculate 3 neighbors of a point when one is invalid" do
      @board.get_neighbors(0,2).should == [ [1,2], [0,1], [0,3] ]
    end

    it "should calculate 2 neighbors of a point when two are invalid" do
      @board.get_neighbors(3,3).should == [ [2,3], [3,2 ] ]
    end
  end

  context "#get_distance_hash" do
    it "should return an empty hash when the end point greater than 
      the board's row size" do
      
      @board.get_distance_hash( [0,0], [BOARD_ROWS,0] ).should == {}
    end
    
    it "should return an empty hash when the end point greater than the 
      board's row size" do
      
      @board.get_distance_hash( [0,0], [0,BOARD_COLUMNS] ).should == {}
    end
    
    it "should return an {} when the end point is greater than both 
      max dimensions" do
      
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
  end
  
  context "#adjacent?" do
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
  end

  context "#shortest_path" do
    it "should calculate the shortest path between two identical points" do
      @board.shortest_path([0,0], [0,0]).should == [ [0,0] ]
    end

    it "should calculate the shortest path between two points of distance 1" do
      @board.shortest_path([0,0], [1,0]).should == [ [0,0], [1,0] ]
    end
    
    it "should calculate the shortest path between two points of distance 2
      that do not include diagonals" do
      
      @board.shortest_path([0,0], [0,2]).should == [ [0,0], [0,1], [0,2] ]
    end
    
    it "should calculate the shortest path between two points of distance 2 
      that includes diagonals" do
      
      correct_answers = [ [[0,0], [0,1], [1,1]], [[0,0], [1,0], [1,1]] ]
      path = @board.shortest_path([0,0], [1,1])
      correct_answers.include?(path).should == true
    end

    it "should calculate the shortest path between two points of distance 2 
      that includes diagonals" do
      
      correct_answers = [ [[0,0], [0,1], [1,1]], [[0,0], [1,0], [1,1]] ]
      path = @board.shortest_path([0,0], [1,1])
      correct_answers.include?(path).should == true
    end
  end
end

describe DustTactics::Space do

  before(:each) do
    @space = Space.new
  end

  it "should be empty when first created" do
    @space.empty?.should == true
  end

  it "should allow a unit to placed on it" do
    unit_stub = Object.new
    @space.occupy(unit_stub)
    @space.resident.should == unit_stub
  end

  it "should allow a unit to be removed from it" do
    unit_stub = Object.new
    @space.occupy(unit_stub)
    @space.evict
    @space.empty?.should == true
  end

  it "should raise an exception when attempting to evict an empty space" do
    lambda { @space.evict }.should raise_error IllegalEviction
  end

end

describe DustTactics::Unit do

  before(:each) do
    hit_points, armor, movement = 3,2,1
    @unit = Unit.new(hit_points, armor, movement)
  end

  it "should have hit_points" do
    @unit.respond_to?(:hit_points).should == true
  end

  it "should have an armor type" do
    @unit.respond_to?(:armor).should == true
  end

  it "should have a movement rating" do
    @unit.respond_to?(:movement).should == true
  end

  it "should be able to sustain damage to its hit_points" do
    original_hit_points = @unit.hit_points
    @unit.take_damage(1).should == original_hit_points - 1
  end

end

describe DustTactics::WeaponLine do

  before(:each) do
    name, type = "Machine Gun", '4'
    combat_values = { :infantry => 
                        { 1 => "6/1", 2 => "4/1", 3 => "3/1", 4 => "2/1"},
                      :veichle =>
                        { 1 => "2/1", 2 => "1/1", 3 => "-", 4 => "-"},
                      :aircraft =>
                        { 1 => "3/1", 2 => "2/1", 3 => "1/1", 4 => "-"}
                    }
    @wl = WeaponLine.new(name, type, combat_values) 
  end

  it "should have a name" do
    @wl.respond_to?(:name).should == true
  end

  it "should have a type" do
    @wl.respond_to?(:type).should == true
  end

  it "should have a combat values" do
    @wl.respond_to?(:combat_values).should == true
  end

  it "should have a return a combat value given the enemy type and armor" do
    @wl.get_combat_value(:infantry, 3).should == "3/1"
  end
end

describe DustTactics::Units::Rhino do
end
