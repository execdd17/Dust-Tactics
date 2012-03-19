module DustTactics::Weapons
  class DualHeavyPIAT < DustTactics::WeaponLine
    
    COMBAT_VALUES = {
                      :infantry =>  { 1=>"10/1",  2=>"6/1", 3=>"4/1", 4=>"2/1"},
                      :vehicle  =>  { 1=>"6/1",   2=>"6/1", 3=>"5/1", 4=>"5/1",
                                      5=>"4/1",   6=>"4/1", 7=>"3/1"},
                      :aircraft =>  { 1=>"-",     2=>"-",   3=>"-"}
                    }

    NAME = "Dual Heavy PIAT"
    TYPE = '2'
    
    def initialize
      super(NAME, TYPE, COMBAT_VALUES)
    end

  end
end
