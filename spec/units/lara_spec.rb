require 'spec_helper'
include DustTactics::Weapons

describe DustTactics::Units::Lara do
  
  before(:each) do
    @laura = Units::Lara.new
  end

  it "should have 4 hit points" do
    @laura.hit_points.should == 4
  end

  it "should have an armor value of 3" do
    @laura.armor.should == 3
  end

  it "should be type infantry" do
    @laura.type.should == :infantry
  end

  it "should have a movement of 1" do
    @laura.movement.should == 1
  end

  it "should have 3 weapon lines" do
    @laura.weapon_lines.length.should == 3
  end

  it "should have two MG 44 zwei and one combat knife" do
    [MG44Zwei, MG44Zwei, CombatKnife].each_with_index do |weapon_class, i|
      @laura.weapon_lines[i].class.should == weapon_class
    end
  end

  it "should have an army point cost of 21" do
    @laura.army_point.should == 21
  end
end
