require 'spec_helper'

describe DustTactics::Units::SoftCover do

  before(:each) do
    @soft_cover = Units::SoftCover.new
  end

  it "should have 2 hit points" do
    @soft_cover.hit_points.should == 2
  end

  it "should be type vehicle" do
    @soft_cover.type.should == :vehicle
  end

  it "should have 3 armor" do
    @soft_cover.armor.should == 3
  end

end

describe DustTactics::Units::HardCover do

  before(:each) do
    @hard_cover = Units::HardCover.new
  end

  it "should have 4 hit points" do
    @hard_cover.hit_points.should == 4
  end

  it "should be type vehicle" do
    @hard_cover.type.should == :vehicle
  end

  it "should have 5 armor" do
    @hard_cover.armor.should == 5
  end

end
