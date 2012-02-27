require 'spec_helper'

describe DustTactics::Space do

  before(:each) do
    @space = Space.new rand(0..10), rand(0..10)
    
    @cover_unit_stub = mock("cover_unit_stub")
    @cover_unit_stub.stub!(:cover?).and_return(true)
    
    @cover_unit_stub2 = mock("cover_unit_stub2")
    @cover_unit_stub2.stub!(:cover?).and_return(true)
    
    @unit_stub = mock("unit_stub")
    @unit_stub.stub!(:cover?).and_return(false)
    
    @unit_stub2 = mock("unit_stub2")
    @unit_stub2.stub!(:cover?).and_return(false)
  end

  it "should be empty when first created" do
    @space.empty?.should == true
  end

  it "should allow a non-cover unit to placed on it" do
    @space.occupy(@unit_stub)
    @space.non_cover.should == @unit_stub
  end
  
  it "should allow a cover unit to placed on it" do
    @space.occupy(@cover_unit_stub)
    @space.cover.should == @cover_unit_stub
  end

  it "should allow a cover unit to be removed from it" do
    @space.occupy(@cover_unit_stub)
    @space.evict(:cover)
    @space.empty?.should == true
  end
  
  it "should allow a non-cover unit to be removed from it" do
    @space.occupy(@unit_stub)
    @space.evict(:unit)
    @space.empty?.should == true
  end

  it "should allow a space to be completely cleared" do
    @space.occupy @unit_stub
    @space.occupy @cover_unit_stub
    @space.evict :all
    @space.empty?.should == true
  end

  it "should raise an exception when attempting to evict an empty space" do
    lambda { @space.evict }.should raise_error IllegalEviction
  end

  it "should raise an exception when attempting to evict a cover unit without
    there actually being one" do

    lambda { @space.evict(:cover) }.should raise_error IllegalEviction
  end
  
  it "should raise an exception when attempting to evict a non -cover unit 
    without there actually being one" do

    lambda { @space.evict(:unit) }.should raise_error IllegalEviction
  end

  it "should allow a non-cover and then cover to be placed" do
    @space.occupy(@unit_stub)
    @space.occupy(@cover_unit_stub)
    [@space.cover, @space.non_cover].should == [@cover_unit_stub, @unit_stub]
  end
  
  it "should allow a cover and then a non-cover to be placed" do
    @space.occupy(@cover_unit_stub)
    @space.occupy(@unit_stub)
    [@space.cover, @space.non_cover].should == [@cover_unit_stub, @unit_stub]
  end
  
  it "should raise an exception when attempting to place two units that are
    both not cover" do
    @space.occupy(@unit_stub)
    lambda { @space.occupy(@unit_stub2) }.should raise_error SpaceOccupied
  end

  it "should raise an exception when attempting to place two cover units" do
    soft_cover, hard_cover = Units::SoftCover.new, Units::HardCover.new
    @space.occupy(soft_cover)
    lambda { @space.occupy(hard_cover) }.should raise_error CoverExists
  end

  it "should know its x coordinate on the board" do
    (Fixnum === @space.x).should == true
  end
  
  it "should know its y coordinate on the board" do
    (Fixnum === @space.y).should == true
  end

  it "should provide a tuple for x and y in the form [x, y]" do
    pending
  end

end

