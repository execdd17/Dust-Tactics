require 'spec_helper'

describe DustTactics::Interactable do 
  describe "#move" do
    before(:each) do
      @board = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @start_space = @board.rand_space
      @unit = [Units::Rhino.new, Units::Lara.new].sample
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
    end
  end

  describe "#attack" do

    before(:each) do
      @board        = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      @target       = [Units::Rhino.new, Units::Lara.new].sample
      @unit         = [Units::Rhino.new, Units::Lara.new].sample
      @weapon_line  = @unit.weapon_lines.first
      @rand_space1  = @board.rand_space
      @rand_space2  = @board.rand_space([@rand_space1])
    end

    it "should raise an exception when attacking a unit not in a space" do
      @unit.deploy(@rand_space1)
      lambda { @unit.attack(@target, @target.space, @weapon_line)
      }.should raise_error InvalidAttack, "The target isn't in a space!"
    end

    it "should raise an exception when the attacker isn't in a space" do
     @target.deploy(@rand_space1)
     lambda { @unit.attack(@target, @target.space, @weapon_line)
     }.should raise_error InvalidAttack, "The attacker isn't in a space!"
    end

    it "should raise an exception when attacking with an unsupported weapon type" do
      @unit.deploy(@rand_space1)
      @target.deploy(@rand_space2)
      @weapon_line.instance_eval { @type = "nonsense" }
      lambda  { @unit.attack(@target, @target.space, @weapon_line) 
      }.should raise_error InvalidAttack,"nonsense is not a supported weapon type"
    end

    it "should actually attack someone and have them take damage" do
      pending
    end
  end

  describe "#los?" do
    before(:each) do
      board  = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      space1 = board.rand_space 
      space2 = board.rand_space([space1])
      
      @unit1 = [Units::Rhino.new, Units::Lara.new].sample
      @unit2 = [Units::Rhino.new, Units::Lara.new].sample

      @unit1.deploy(space1) 
      @unit2.deploy(space2)
    end
  
    it "should return true when one unit has line of sight to the other" do
      @unit1.los?(@unit2).should == true
    end
  end

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
      wls_in_range.each { |wl| (HeavyRocketPunch === wl).should == true }
    end
    
    it "should return both range weapon lines when Lara is 4 spaces
      away from Rhino" do
      
      @rhino.deploy(@board.space(0,0)) and @lara.deploy(@board.space(0,4))
      wls_in_range = @lara.weapons_in_range(@board, @rhino, @lara.weapon_lines)
      wls_in_range.each { |wl| (MG44Zwei === wl).should == true }
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
