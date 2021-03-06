require 'spec_helper'

describe DustTactics::Interactable do 
  describe "#activated?" do
    before(:each) do
      @board        = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @unit         = rand_interactable_unit
    end

    it "should not be activated when first created" do
      @unit.should_not be_activated
    end

    it "should be activated once signaled" do
      @unit.activate
      @unit.should be_activated
    end

    it "should not be activated after being deactivated" do
      @unit.activate and @unit.deactivate
      @unit.should_not be_activated
    end

    it "should raise an error when trying to activate twice" do
      @unit.activate
      lambda { @unit.activate }.should raise_error DuplicateActivation
    end
    
    it "should raise an error when trying to deactivate twice" do
      lambda { @unit.deactivate }.should raise_error DuplicateDeactivation
    end
  end

  describe "#move" do
    before(:each) do
      @board        = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @start_space  = @board.rand_space
      @unit         = rand_interactable_unit
    end
  
    it "should occupy its end point when moving" do
      valid_moves = @board.valid_moves(@start_space.point, @unit.movement)
      rand_space  = @board.space(valid_moves[rand(1..(valid_moves.length))].sample)

      @unit.deploy(@start_space)
      @unit.move(rand_space)
      rand_space.non_cover.should == @unit
    end

    it "should raise an exception when attempting to move when not in a space" do
      lambda { @unit.move(@board.rand_space) }.should raise_error NotInSpace
    end

    it "should clear its start point when moving" do
      valid_moves = @board.valid_moves(@start_space.point, @unit.movement)
      rand_space  = @board.space(valid_moves[rand(1..(valid_moves.length))].sample)

      @unit.deploy(@start_space)
      @unit.move(rand_space)
      @start_space.non_cover.should == nil
    end

    it "should use the path finding algorithm instead of just plopping down" do
      pending
      fail
    end
  end

  describe "#attack" do

    before(:each) do
      @board          = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @ranged_battle  = deployment_factory(@board, :ranged_combat)   
      @cc_battle      = deployment_factory(@board, :close_combat)    
      @random_battle  = deployment_factory(@board, :random)       
    end

    it "should raise an exception when attacking from out of range" do
      attacker, defender = @random_battle
      weapon_line = rand_weapon_line(attacker).instance_eval { @type = '0' }
      
      lambda { attacker.attack(@board, defender, [weapon_line])
      }.should raise_error InvalidAttack, /is not in range to attack!$/
    end

    it "should raise an exception when attacking a unit not in a space" do
      attacker, defender  = @random_battle.first, rand_interactable_unit
      weapon_line         = rand_weapon_line(attacker)
      
      lambda { attacker.attack(@board, defender, [weapon_line])
      }.should raise_error InvalidAttack, "The target isn't in a space!"
    end

    it "should raise an exception when the attacker isn't in a space" do
      attacker, defender  = rand_interactable_unit, @random_battle.last
      weapon_line         = rand_weapon_line(attacker)
      
      lambda { attacker.attack(@board, defender, [weapon_line])
      }.should raise_error InvalidAttack, "The attacker isn't in a space!"
    end

    it "should raise an exception when attacking with an unsupported weapon type" do
      attacker, defender = @random_battle
      weapon_line = rand_weapon_line(attacker).instance_eval { @type = '^-^' }

      lambda  { attacker.attack(@board, defender, [weapon_line]) 
      }.should raise_error InvalidAttack,"^-^ is not a supported weapon type"
    end

    it "should correctly take soft cover into consideration when attacking" do
      attacker, defender = @ranged_battle
      Units::SoftCover.new.deploy(defender.space)
      
      ranged_weapon = attacker.weapon_lines.select { |wl| wl.type =~ /\d/ }.first
      cover_saves = 100.times.inject(0) do |memo, i|
        battle_report = attacker.attack(@board, defender, [ranged_weapon])
        memo += battle_report[:attacker][:target_cover_saves]
      end

      cover_saves.should be > 0
    end
    
    it "should correctly take hard cover into consideration when attacking" do
      attacker, defender = @ranged_battle
      Units::HardCover.new.deploy(defender.space)
      
      ranged_weapon = attacker.weapon_lines.select { |wl| wl.type =~ /\d/ }.first
      cover_saves = 100.times.inject(0) do |memo, i|
        battle_report = attacker.attack(@board, defender, [ranged_weapon])
        memo += battle_report[:attacker][:target_cover_saves]
      end

      cover_saves.should be > 0
    end

    it "should correctly cause damage to the target player with a ranged weapon" do
      attacker, defender = @ranged_battle
      defender_initial_hp = defender.hit_points

      ranged_weapon = attacker.weapon_lines.select { |wl| wl.type =~ /\d/ }.first
      battle_report = attacker.attack(@board, defender, [ranged_weapon])
      expected_hp   = defender_initial_hp - battle_report[:attacker][:net_hits]
      defender.hit_points.should ==  expected_hp   
    end

    it "should not cause damage to the attacker when using a ranged weapon" do
      attacker, defender = @ranged_battle
      attacker_initial_hp = attacker.hit_points

      ranged_weapon = attacker.weapon_lines.select { |wl| wl.type =~ /\d/ }.first
      battle_report = attacker.attack(@board, defender, [ranged_weapon])
      attacker.hit_points.should ==  attacker_initial_hp
    end

    it "should cause damage to the defender when using close combat" do
      attacker, defender = @cc_battle
      defender_initial_hp = defender.hit_points

      cc_weapon     = attacker.weapon_lines.select { |wl| wl.type == 'C' }.first
      battle_report = attacker.attack(@board, defender, [cc_weapon])
      expected_hp   = defender_initial_hp - battle_report[:attacker][:net_hits]
      defender.hit_points.should ==  expected_hp   
    end
    
    it "should cause damage to the attaker when both parties have cc weapons" do
      attacker, defender = @cc_battle
      attacker_initial_hp = attacker.hit_points

      cc_weapon     = attacker.weapon_lines.select { |wl| wl.type == 'C' }.first
      battle_report = attacker.attack(@board, defender, [cc_weapon])
      expected_hp   = attacker_initial_hp - battle_report[:defender][:net_hits]
      attacker.hit_points.should ==  expected_hp   
    end

    it "should return a battle report containing attacker data " <<
       "when both units have close combat weapons to attack with" do

      attacker, defender = @cc_battle
      battle_report = attacker.attack(@board, defender, attacker.weapon_lines) 
      battle_report[:attacker].should_not be nil
    end
    
    it "should return a battle report containing defender data " <<
       "when both units have close combat weapons to attack with" do

      attacker, defender = @cc_battle
      battle_report = attacker.attack(@board, defender, attacker.weapon_lines) 
      battle_report[:defender].should_not be nil
    end

    it "should not return the same number of dice rolled when two viable " << 
       "weapon lines are ussed to attack" do
      
      attacker, defender = @cc_battle
      single_line       = attacker.weapon_lines.first
      single_line_dice  = single_line.num_dice(defender.type, defender.armor)
      
      all_weapons       = attacker.weapon_lines
      all_weapons_dice  = all_weapons.inject(0) do |sum, wl| 
        sum += wl.num_dice(defender.type, defender.armor)
      end

      battle_report = attacker.attack(@board, defender, all_weapons)
      battle_report[:attacker][:num_rolls].should_not == single_line_dice
    end
    
    it "should return the correct total number of dice when given " << 
       "more than one weapon line" do
      
      attacker, defender = @cc_battle
      single_line       = attacker.weapon_lines.first
      single_line_dice  = single_line.num_dice(defender.type, defender.armor)
      
      all_weapons       = attacker.weapon_lines
      all_weapons_dice  = all_weapons.inject(0) do |sum, wl| 
        sum += wl.num_dice(defender.type, defender.armor)
      end

      battle_report = attacker.attack(@board, defender, all_weapons)
      battle_report[:attacker][:num_rolls].should == all_weapons_dice
    end
  end

  describe "#los?" do
    before(:each) do
      board  = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @unit1, @unit2 = deployment_factory(board, :random)
    end
  
    it "should return true when one unit has line of sight to the other" do
      @unit1.los?(@unit2).should == true
    end

    it "should return false when something is blocking line of sight" do
      pending "Currently, the idea of obstacles does not exist"
      fail
    end
  end

  #TODO: These should not be written in the perspective of particular units
  # For example, instead of, ... when Rhino is one space away, do:
  # should return 2 weapon lines when a unit has two close combat weapons
  # and is located one space away
  describe "#weapons_in_range" do
    before(:each) do
      @board        = Board.new(6, 6)
      @rhino        = Units::Rhino.new
      @lara         = Units::Lara.new
    end

    it "should return an empty array when Rhino is out of range" do
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,2))
      wls_in_range = @rhino.weapons_in_range(@board, @lara, @rhino.weapon_lines)
      wls_in_range.should == []
    end
    
    it "should return 2 weapon lines when Rhino is one space away" do
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,1))
      wls_in_range = @rhino.weapons_in_range(@board, @lara, @rhino.weapon_lines)
      wls_in_range.length.should == 2
    end
    
    it "should return both close combat weapon lines when rhino is one space
      away from lara" do
      
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,1))
      wls_in_range = @rhino.weapons_in_range(@board, @lara, @rhino.weapon_lines)
      wls_in_range.each { |wl| (Weapons::HeavyRocketPunch === wl).should == true }
    end
    
    it "should return both range weapon lines when Lara is 4 spaces
      away from Rhino" do
      
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,4))
      wls_in_range = @lara.weapons_in_range(@board, @rhino, @lara.weapon_lines)
      wls_in_range.each { |wl| (Weapons::MG44Zwei === wl).should == true }
    end
    
    it "should return an empty array when Lara is out of range" do
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,5))
      wls_in_range = @lara.weapons_in_range(@board, @rhino, @lara.weapon_lines)
      wls_in_range.should == []
    end
    
    it "should return 3 weapon lines when Lara is 1 space from her target" do
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,1))
      wls_in_range = @lara.weapons_in_range(@board, @rhino, @lara.weapon_lines)
      wls_in_range.length.should == 3
    end
  end
end

