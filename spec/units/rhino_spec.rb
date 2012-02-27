require 'spec_helper'

describe DustTactics::Units::Rhino do

  before(:each) do
    @rhino = Units::Rhino.new
  end

  it "should have two weapon lines" do
    @rhino.weapon_lines.length.should == 2
  end

  it "should have 4 hit points" do
    @rhino.hit_points.should == 4
  end

  it "should be type infantry" do
    @rhino.type.should == :infantry
  end

  it "should have an armor rating of 3" do
    @rhino.armor.should == 3
  end
end
