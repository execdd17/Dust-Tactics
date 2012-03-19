require 'spec_helper'
include DustTactics::Weapons

describe DustTactics::Units::HeavyLaserGrenadiers do
  
  before(:each) do
    @grenadiers = Units::HeavyLaserGrenadiers.new
  end

  it "should have 3 hit points" do
    @grenadiers.hit_points.should == 3
  end

  it "should have an armor value of 3" do
    @grenadiers.armor.should == 3
  end

  it "should be type infantry" do
    @grenadiers.type.should == :infantry
  end

  it "should have a movement of 1" do
    @grenadiers.movement.should == 1
  end

  it "should have 2 weapon lines" do
    @grenadiers.weapon_lines.length.should == 2
  end

  it "should have one Schwer Laser-Werfer and one combat knife" do
    [SchwerLaserWerfer, CombatKnife].each_with_index do |weapon_class, i|
      @grenadiers.weapon_lines[i].class.should == weapon_class
    end
  end

  it "should have an army point cost of 30" do
    @grenadiers.army_point.should == 30
  end
end
