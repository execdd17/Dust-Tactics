require 'spec_helper'

describe DustTactics::Unit do

  before(:each) do
    hit_points, type, armor, movement, ap = 3, :infantry, 2, 1, 30
    @unit = Unit.new(hit_points, type, armor, movement, ap)
  end
  
  it "should have hit_points" do
    @unit.respond_to?(:hit_points).should == true
  end

  it "should have a type" do
    @unit.respond_to?(:type).should == true
  end

  it "should have an armor type" do
    @unit.respond_to?(:armor).should == true
  end

  it "should have a movement rating" do
    @unit.respond_to?(:movement).should == true
  end

  it "should be able to sustain damage to its hit_points" do
    original_hit_points = @unit.hit_points
    @unit.take_damage(1).should == original_hit_points - 1
  end

  it "should have an army point cost associated with it" do
    @unit.army_point.should_not == nil
  end

  it "should be clear its start point when moving" do
    board, unit = Board.new(4,4), Units::Rhino.new
    start_pt    = board.rand_point
    valid_moves = board.valid_moves(start_pt, unit.movement)
    rand_move   = valid_moves[rand(1..(valid_moves.length))].sample

    board.space(start_pt).occupy(unit)
    board.space(start_pt).non_cover.move(board, start_pt, rand_move)
    board.space(start_pt).non_cover.should == nil
  end

end

