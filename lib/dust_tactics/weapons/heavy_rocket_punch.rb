module DustTactics::Weapons
  class HeavyRocketPunch < DustTactics::WeaponLine
    
    COMBAT_VALUES = {
                      :infantry =>  { 1=>"8/1", 2=>"4/1", 3=>"2/1", 4=>"1/1"},
                      :vehicle  =>  { 1=>"1/1", 2=>"1/1", 3=>"1/1", 4=>"1/1",
                                      5=>"1/1", 6=>"1/1", 7=>"1/1"},
                      :aircraft =>  { 1=>"-",   2=>"-",   3=>"-"}
                    }

    NAME = "Heavy Rocket Punch"
    TYPE = 'C'
    
    def initialize
      super(NAME, TYPE, COMBAT_VALUES)
    end

  end
end
