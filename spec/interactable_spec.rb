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

      @unit.occupy(@start_space)
      @unit.move(rand_space)
      rand_space.non_cover.should == @unit
    end

    it "should raise an exception when attempting to move when not in a space" do
      lambda { @unit.move(@board.rand_space) }.should raise_error NotInSpace
    end

    it "should clear its start point when moving" do
      valid_moves = @board.valid_moves(@start_space.point, @unit.movement)
      rand_space  = @board.space(valid_moves[rand(1..(valid_moves.length))].sample)

      @unit.occupy(@start_space)
      @unit.move(rand_space)
      @start_space.non_cover.should == nil
    end
  end

  describe "#attack" do
    it "should work right" do
      pending
    end
  end

  describe "#los?" do
    before(:each) do
      board  = Board.new(BOARD_ROWS, BOARD_COLUMNS)
      space1 = board.rand_space 
      space2 = board.rand_space([@space1])
      
      @unit1 = [Units::Rhino.new, Units::Lara.new].sample
      @unit2 = [Units::Rhino.new, Units::Lara.new].sample
      
      @unit1.occupy(space1) 
      @unit2.occupy(space2)
    end
  
    it "should return true when one unit has line of sight to the other" do
      pending
    end
  end
end
