require 'spec_helper'

describe DustTactics::Units::Rhino do

  before(:each) do
    @rhino = Units::Rhino.new
  end

  it "should have two weapon lines" do
    @rhino.weapon_lines.length.should == 2
  end
end
