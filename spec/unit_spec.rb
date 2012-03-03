require 'spec_helper'

describe DustTactics::Unit do

  before(:each) do
    hit_points, type, armor, movement, ap = 3, :infantry, 2, 1, 30
    @unit = Unit.new(hit_points, type, armor, movement, ap)
    
    board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @space= board.rand_space
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
    @unit.deploy(@space)
    @unit.in_space?.should == true
  end

  it "should raise an error when trying to deploy in a nil space" do
    lambda { @unit.deploy(nil) 
    }.should raise_error InvalidDeployment, "Deployment Space Invalid"
  end
  
  it "should determine when it's not inside a space" do
    @unit.in_space?.should == false
  end

  it "should raise an exception when attempting to use deploy as a move" do
    @unit.deploy(Space.new 0,0)
    lambda { @unit.deploy(Space.new 0,1) }.should raise_error InvalidDeployment
  end
end
