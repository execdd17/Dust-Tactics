require 'spec_helper'

describe DustTactics::Player do

  before(:each) do
    board   = Board.new(4,4)
    @player = Player.new("Franky Four Fingers", "axis", board)
  end

  it "should have a name" do
    @player.name.should_not == nil
  end

  it "should be part of the axis or allied team" do
    ["axis", "allies"].include?(@player.team).should == true
  end

  it "should have an empty set of units to start with" do
    @player.units.should == []
  end

  it "should accept a unit for his team" do
    unit = Units::Rhino.new
    @player.add_unit(unit).should == [unit]
  end

  it "should have a total army point cost of 0 without an army" do
    @player.total_ap.should == 0
  end

  it "should have a total of 22 army points after adding Rhino" do
    @player.add_unit Units::Rhino.new
    @player.total_ap.should == 22
  end

  it "should remove a unit from his team" do
    pending
  end

  it "should move a unit" do
    pending
  end

end
