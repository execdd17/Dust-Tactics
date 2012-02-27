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

end

