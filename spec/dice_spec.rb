require 'spec_helper'

describe DustTactics::DiceEngine do
  
  MIN_DICE, MAX_DICE = 1, 50

  describe ".roll" do
    before(:each) do 
      @num_dice = rand(MIN_DICE..MAX_DICE)
    end

    it "should return a hash with hit/miss keys" do
      DiceEngine.roll(@num_dice).keys.should == [:hits, :misses]
    end

    it "should return a hash an integer value total greater than zero" do
      DiceEngine.roll(@num_dice).values.inject(:+).should > 0
    end

    it "should return a hash with values that total num_dice" do
      DiceEngine.roll(@num_dice).values.inject(:+).should == @num_dice
    end
  end

end
