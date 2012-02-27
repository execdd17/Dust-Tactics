require 'spec_helper'

describe DustTactics::Player do

  before(:each) do
    board   = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @player = Player.new("Franky Four Fingers", "axis", board)
    @unit   = Units::Rhino.new
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
    @player.add_unit(@unit) 
    @player.remove_unit(@unit).should == []
  end

  it "should move one of its unit and end up there" do
    start_space = @player.board.space(0,0)
    end_space   = @player.board.space(0,1)
  
    @player.add_unit(@unit)
    @unit.occupy(start_space)
    @player.move_unit(@unit, end_space)
    end_space.non_cover.should == @unit
  end
  
  it "should move one of its unit and not still be in the start space" do
    start_space = @player.board.space(0,0)
    end_space   = @player.board.space(0,1)
  
    @player.add_unit(@unit)
    @unit.occupy(start_space)
    @player.move_unit(@unit, end_space)
    start_space.non_cover.should == nil
  end

end
