module DustTactics::Weapons
  class MG44Zwei < DustTactics::WeaponLine
    
    COMBAT_VALUES = {
                      :infantry =>  { 1=>"10/1",  2=>"5/1", 3=>"3/1", 4=>"-"},
                      :vehicle  =>  { 1=>"4/1",   2=>"3/1", 3=>"-",   4=>"-",
                                      5=>"-",     6=>"-",   7=>"-"},
                      :aircraft =>  { 1=>"3/1",   2=>"3/1", 3=>"-"}
                    }

    NAME = "MG 44 zwei"
    TYPE = '4'
    
    def initialize
      super(NAME, TYPE, COMBAT_VALUES)
    end

  end
end
