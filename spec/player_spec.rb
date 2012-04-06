require 'spec_helper'

describe DustTactics::Player do

  before(:each) do
    board   = Board.new(BOARD_ROWS, BOARD_COLUMNS)
    @player = Player.new("Franky Four Fingers", "axis", board)
    @unit   = rand_interactable_unit
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
  
  it "should deploy a non cover unit and end up there" do
    start_space = @player.board.rand_space
  
    @player.add_unit(@unit) 
    @player.deploy_unit(@unit, start_space)
    start_space.non_cover.should == @unit
  end
  
  it "should deploy a cover unit and end up there" do
    start_space = @player.board.rand_space
    cover_unit  = Units::HardCover.new
  
    @player.add_unit(cover_unit) 
    @player.deploy_unit(cover_unit, start_space)
    start_space.cover.should == cover_unit
  end
  
  it "should not allow a player to move a non-interactable" do
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
    cover_unit  = Units::SoftCover.new
  
    @player.add_unit(cover_unit)
    @player.deploy_unit(cover_unit, start_space)
    
    lambda do 
      @player.move_unit(cover_unit, end_space) 
    end.should raise_error BusyHands, "Only Interactables Can Move" 
  end
  
  it "should move one of its units and end up there" do
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
  
    @player.add_unit(@unit)
    @unit.deploy(start_space)
    @player.move_unit(@unit, end_space)
    end_space.non_cover.should == @unit
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
    lambda { @player.move_unit(@unit, nil) }.should raise_error BusyHands
  end
      
  it "should raise an exception when attempting to move a unit without " << 
     "enough ticks" do
    
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
    
    @player.ticks= 0
    @player.add_unit(@unit)
    @unit.deploy(start_space)
    
    lambda do
      @player.move_unit(@unit, end_space)
    end.should raise_error BigSpender, "Not Enough Ticks!"
  end

  it "should raise an exception when attempting to attack a unit without " << 
     "enough ticks" do
    
    start_space = @player.board.rand_space
    end_space   = @player.board.rand_space( [start_space] )
    
    @player.ticks= 0
    @player.add_unit(@unit)
    @unit.deploy(start_space)
    
    lambda do
      @player.attack_unit(nil,nil,nil)
    end.should raise_error BigSpender, "Not Enough Ticks!"
  end

  it "should raise an exception when attempting to skip an action without " << 
     "enough ticks" do
    
    @player.ticks= 0
    
    lambda do
      @player.skip_action
    end.should raise_error BigSpender, "Not Enough Ticks!"
  end
  
  it "should allow the option to skip an action" do
    lambda { @player.skip_action }.should_not raise_error
  end

  it "should allow the option to attack a unit" do
    attacker, defender = deployment_factory(@board, :close_combat)
    lambda do 
      @player.attack_unit(attacker, defender, attacker.weapon_lines)
    end.should_not raise_error
  end

  it "should remove the defeated unit from the oponent's units array" do
    pending "This needs to be done in another object that has knowledge " <<
            "of both players, because units don't know who they belong to"
  end

  describe "a turn finate state machine" do
    describe "possible transitions" do

      before(:each) { @player = Player.new nil, nil, nil }

      it "should allow the transition from start to performed_sustained attack" do
        @player.can_sustained_attack?.should == true
      end

      it "should deduct the correct amount of ticks for a given action" do
        starting_ticks = @player.ticks= 3
        @player.sustained_attack
        @player.ticks.should == starting_ticks - @player.tick_cost
      end

      it "should allow the transition from start to attacked" do
        @player.can_attack?.should == true
      end

      it "should allow the transition from start to moved" do
        @player.can_move?.should == true
      end

      it "should allow the transition from start to did_nothing" do
        @player.can_do_nothing?.should == true
      end

      it "should allow the transition from did_nothing to did_nothing" do
        @player.do_nothing
        @player.can_do_nothing?.should == true
      end

      it "should allow the transition from did_nothing to moved" do
        @player.do_nothing
        @player.can_move?.should == true
      end

      it "should allow the transition from did_nothing attacked" do
        @player.do_nothing
        @player.can_attack?.should == true
      end

      it "should allow the transition from attacked to did_nothing" do
        @player.attack
        @player.can_do_nothing?.should == true
      end

      it "should allow the transition from moved to did_nothing" do
        @player.move
        @player.can_do_nothing?.should == true
      end

      it "should allow the transition from moved to moved" do
        @player.move
        @player.can_move?.should == true
      end
      
      it "should allow the transition from moved to attack" do
        @player.move
        @player.can_attack?.should == true
      end
    end
  end
end
