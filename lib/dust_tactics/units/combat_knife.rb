module DustTactics::Weapons
  class CombatKnife < DustTactics::WeaponLine
    
    COMBAT_VALUES = {
                      :infantry =>  { 1=>"4/1",   2=>"2/1", 3=>"1/1", 4=>"1/1"},
                      :vehicle  =>  { 1=>"-",     2=>"-",   3=>"-",   4=>"-",
                                      5=>"-",     6=>"-",   7=>"-"},
                      :aircraft =>  { 1=>"-",     2=>"-",   3=>"-"}
                    }

    NAME = "Combat Knife"
    TYPE = 'C'
    
    def initialize
      super(NAME, TYPE, COMBAT_VALUES)
    end

  end
end
