require 'spec_helper'

describe DustTactics::Player do
  describe "basic functionality" do
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
        
    it "should remove a unit from his team" do
      @player.add_unit(@unit) 
      @player.remove_unit(@unit).should == []
    end

    it "should have a total army point cost of 0 without an army" do
      @player.total_ap.should == 0
    end

    it "should have the correct total of army points after adding a unit" do
      @player.add_unit(@unit)
      @player.total_ap.should == @unit.army_point
    end
        
    it "should deploy a cover unit and end up there" do
      start_space = @player.board.rand_space
      cover_unit  = Units::HardCover.new
    
      @player.add_unit(cover_unit) 
      @player.deploy_cover(cover_unit, start_space)
      start_space.cover.should == cover_unit
    end

    it "should know when there are no more units to activate" do
      @player.should_not have_activatable_units
    end

    it "should know when there are more units to activate" do
      @player.add_unit(@unit)
      @player.should have_activatable_units
    end

    it "should return a list of units that can be activated this round" do
      @player.add_unit(@unit)
      @player.activatable_units.should == [@unit]
    end

    it "should reset all units to deactivated" do
      @player.add_unit(@unit)
      @player.activate(@unit)
      @player.reset_round
      @player.activatable_units.include?(@unit).should == true
    end
  end

  describe "a turn finate state machine" do
    describe "possible transitions" do

      before(:each) do 
        @unit = rand_interactable_unit
        @board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
        @player = Player.new("", "", @board)
        @player.add_unit(@unit)
      end

      it "should allow sustained_attack from activated" do
        @player.activate(@unit)
        @player.can_sustained_attack?.should == true
      end

      it "should deduct the correct amount of ticks for a given action" do
        pending
        fail

        # starting_ticks = @player.instance_eval { @ticks= 3 }
        # @player.activate(@unit)
        # @player.sustained_attack
        # @player.ticks.should == starting_ticks - @player.tick_cost
      end

      it "should allow attack from activated" do
        @player.activate(@unit)
        @player.can_attack?.should == true
      end

      it "should allow move from activated" do
        @player.activate(@unit)
        @player.can_move?.should == true
      end

      it "should allow do_nothing from activated" do
        @player.activate(@unit)
        @player.can_do_nothing?.should == true
      end

      it "should allow do_nothing from did_nothing" do
        @player.activate(@unit)
        @player.do_nothing
        @player.can_do_nothing?.should == true
      end

      it "should allow move from did_nothing" do
        @player.activate(@unit)
        @player.do_nothing
        @player.can_move?.should == true
      end

      it "should allow attack from did_nothing" do
        @player.activate(@unit)
        @player.do_nothing
        @player.can_attack?.should == true
      end

      it "should allow do_nothing from attacked" do
        attacker, defender = deployment_factory(@board, :ranged_combat)
        @player.add_unit(attacker)
        @player.instance_eval { @ticks = 3 }
        @player.activate(attacker)
        @player.attack(defender, attacker.weapon_lines)
        @player.can_do_nothing?.should == true
      end

      it "should allow do_nothing from moved" do
        @unit.deploy(Space.new(0,0))
        @player.activate(@unit)
        @player.move(Space.new(0,1))
        @player.can_do_nothing?.should == true
      end

      it "should allow move from moved" do
        @unit.deploy(Space.new(0,0))
        @player.activate(@unit)
        @player.move(Space.new(0,1))
        @player.can_move?.should == true
      end
      
      it "should allow attack from moved" do
        @unit.deploy(Space.new(0,0))
        @player.activate(@unit)
        @player.move(Space.new(0,1))
        @player.can_attack?.should == true
      end
    end

    describe "transition functionality" do
      before(:each) do
        board   = Board.new(BOARD_ROWS, BOARD_COLUMNS)
        @player = Player.new("Franky Four Fingers", "axis", board)
        @unit   = rand_interactable_unit
        @player.add_unit(@unit)
        @start_space = @player.board.rand_space
        @end_space   = @player.board.rand_space( [@start_space] )
      end

      it "should deploy a non cover unit and end up there" do
        @player.activate(@unit)
        @player.deploy(@start_space)
        @start_space.non_cover.should == @unit
      end
      
      it "should not allow a player to activate a non-interactable" do
        cover_unit  = Units::SoftCover.new
        @player.add_unit(cover_unit)
        
        lambda do 
          @player.activate(cover_unit)
        end.should raise_error BusyHands, "Only interactables can be activated" 
      end
     
      it "should move one of its units and end up there" do
        @player.activate(@unit)
        @player.deploy(@start_space)
        @player.move(@end_space)
        @end_space.non_cover.should == @unit
      end

      it "should move one of its unit and not still be in the start space" do
        @player.add_unit(@unit)
        @player.activate(@unit)
        @player.deploy(@start_space)
        @player.move(@end_space)
        @start_space.non_cover.should == nil
      end

      it "should raise an exception when trying to activate a unit that it doesn't own" do
        lambda { @player.activate(rand_interactable_unit)}.should raise_error BusyHands
      end
          
      it "should raise an exception when attempting to move a unit without " << 
         "enough ticks" do
        
        @player.instance_eval { @ticks= 0 }
        @player.add_unit(@unit)
        @player.activate(@unit)
        @unit.deploy(@start_space)
        
        lambda do
          @player.move(@end_space)
        end.should raise_error BigSpender, "Not Enough Ticks!"
      end

      it "should raise an exception when attempting to attack a unit without " << 
         "enough ticks" do
        
        @player.instance_eval { @ticks= 0 }
        @player.add_unit(@unit)
        @player.activate(@unit)
        @unit.deploy(@start_space)
        
        lambda do
          @player.attack(nil,nil)
        end.should raise_error BigSpender, "Not Enough Ticks!"
      end

      it "should raise an exception when attempting to skip an action without " << 
         "enough ticks" do
        
        @player.instance_eval { @ticks= 0 }
        @player.add_unit(@unit)
        @player.activate(@unit)
        
        lambda do
          @player.do_nothing
        end.should raise_error BigSpender, "Not Enough Ticks!"
      end

      it "should restore the original amount of ticks when restart is triggered" do
        orig_ticks = @player.ticks
        @player.activate(@unit)
        
        until @player.ticks == 0
          @player.do_nothing
        end

        @player.restart
        expect @player.ticks == orig_ticks
      end
      
      it "should allow the option to perform a sustained attack" do
        pending "Having this method, and all action methods visible " <<
                "only when available would we cool"
        fail
      end 

      it "should remove the defeated unit from the oponent's units array" do
        pending "This needs to be done in another object that has knowledge " <<
                "of both players, because units don't know who they belong to"
        fail
      end
    end
  end
end
