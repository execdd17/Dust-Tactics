require 'spec_helper'

describe DustTactics::Player do

  before(:each) do
    board   = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @player = Player.new("Franky Four Fingers", "axis", board)
    @unit   = [Units::Rhino.new, Units::Lara.new].sample
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
    @player.add_unit(@unit).should == [@unit]
  end

  it "should have a total army point cost of 0 without an army" do
    @player.total_ap.should == 0
  end

  it "should have the correct total of army points after adding a unit" do
    @player.add_unit(@unit)
    @player.total_ap.should == @unit.army_point
  end

  it "should remove a unit from his team" do
    @player.add_unit(@unit) 
    @player.remove_unit(@unit).should == []
  end

  it "should move one of its units and end up there" do
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
  
    @player.add_unit(@unit)
    @unit.deploy(start_space)
    @player.move_unit(@unit, end_space)
    end_space.non_cover.should == @unit
  end
  
  it "should move one of its unit and not still be in the start space" do
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
  
    @player.add_unit(@unit)
    @unit.deploy(start_space)
    @player.move_unit(@unit, end_space)
    start_space.non_cover.should == nil
  end

  it "should raise an exception when trying to move a unit it doesn't own" do
    pending
  end
    
  #TODO: toss this an use a FSM instead! Make it an instance variable of player
  describe "#perform_turn" do

    before(:each) do
      board   = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @player = Player.new("Franky Four Fingers", "axis", board)
      @attacker, @defender = rand_interactable_unit, rand_interactable_unit
    end

    it "should perform a move action" do
      pending "FSM!"
    end

    it "should perform an attack action" do
      pending "FSM!"
    end

  end

end
