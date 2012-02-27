require 'spec_helper'

describe DustTactics::Space do

  before(:each) do
    @space = Space.new
  end

  it "should be empty when first created" do
    @space.empty?.should == true
  end

  it "should allow a unit to placed on it" do
    unit_stub = Object.new
    @space.occupy(unit_stub)
    @space.resident.should == unit_stub
  end

  it "should allow a unit to be removed from it" do
    unit_stub = Object.new
    @space.occupy(unit_stub)
    @space.evict
    @space.empty?.should == true
  end

  it "should raise an exception when attempting to evict an empty space" do
    lambda { @space.evict }.should raise_error IllegalEviction
  end

end

