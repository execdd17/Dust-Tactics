require 'spec_helper'

describe DustTactics::Unit do

  before(:each) do
    hit_points, type, armor, movement, ap = 3, :infantry, 2, 1, 30
    @unit = Unit.new(hit_points, type, armor, movement, ap)
  end
  
  it "should have hit_points" do
    @unit.respond_to?(:hit_points).should == true
  end

  it "should have a type" do
    @unit.respond_to?(:type).should == true
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

  it "should have an army point cost associated with it" do
    @unit.army_point.should_not == nil
  end

  it "should determine when it's inside a space" do
    space = Space.new(0,0)
    @unit.occupy(space)
    @unit.in_space?.should == true
  end
  
  it "should determine when it's not inside a space" do
    space = Space.new(0,0)
    @unit.in_space?.should == false
  end
end

describe DustTactics::Interactable do 
  before(:each) do
    @board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @start_space = @board.space(@board.rand_point)
    @unit = Units::Rhino.new
  end
  
  it "should occupy its end point when moving" do
    valid_moves = @board.valid_moves(@start_space.point, @unit.movement)
    rand_space  = @board.space(valid_moves[rand(1..(valid_moves.length))].sample)

    @unit.occupy(@start_space)
    @unit.move(rand_space)
    rand_space.non_cover.should == @unit
  end

  it "should clear its start point when moving" do
    valid_moves = @board.valid_moves(@start_space.point, @unit.movement)
    rand_space  = @board.space(valid_moves[rand(1..(valid_moves.length))].sample)

    @unit.occupy(@start_space)
    @unit.move(rand_space)
    @start_space.non_cover.should == nil
  end
  
end

