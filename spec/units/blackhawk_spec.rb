require 'spec_helper'
include DustTactics::Weapons

describe DustTactics::Units::BlackHawk do
  
  before(:each) do
    @blackhawk = Units::BlackHawk.new
  end

  it "should have 3 hit points" do
    @blackhawk.hit_points.should == 3
  end

  it "should have an armor value of 3" do
    @blackhawk.armor.should == 3
  end

  it "should be type vehicle" do
    @blackhawk.type.should == :vehicle
  end

  it "should have a movement of 1" do
    @blackhawk.movement.should == 1
  end

  it "should have 1 weapon line" do
    @blackhawk.weapon_lines.length.should == 1
  end

  it "should have one Dual Heavy PIAT" do
    [DualHeavyPIAT].each_with_index do |weapon_class, i|
      @blackhawk.weapon_lines[i].class.should == weapon_class
    end
  end

  it "should have an army point cost of 22" do
    @blackhawk.army_point.should == 22
  end
end
