require 'spec_helper'

describe DustTactics::WeaponLine do

  before(:each) do
    name, type = "Machine Gun", '4'
    combat_values = { :infantry => 
                        { 1 => "6/1", 2 => "4/1", 3 => "3/1", 4 => "2/1"},
                      :veichle =>
                        { 1 => "2/1", 2 => "1/1", 3 => "-", 4 => "-"},
                      :aircraft =>
                        { 1 => "3/1", 2 => "2/1", 3 => "1/1", 4 => "-"}
                    }
    @wl = WeaponLine.new(name, type, combat_values) 
  end

  it "should have a name" do
    @wl.respond_to?(:name).should == true
  end

  it "should have a type" do
    @wl.respond_to?(:type).should == true
  end

  it "should have a combat values" do
    @wl.respond_to?(:combat_values).should == true
  end

  it "should have a return a combat value given the enemy type and armor" do
    @wl.get_combat_value(:infantry, 3).should == "3/1"
  end

  it "should know when it's not a close combat type" do
    @wl.close_combat?.should == false
  end
  
  it "should know when it is a close combat type" do
    WeaponLine.new("Sharp Stick", 'C', {}).close_combat?.should == true
  end
end
