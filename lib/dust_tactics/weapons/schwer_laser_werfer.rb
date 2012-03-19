module DustTactics::Weapons
  class SchwerLaserWerfer < DustTactics::WeaponLine
    
    COMBAT_VALUES = {
                      :infantry =>  { 1=>"2/1",   2=>"1/1", 3=>"1/1", 4=>"1/1"},
                      :vehicle  =>  { 1=>"1/3",   2=>"1/3", 3=>"1/3", 4=>"1/3",
                                      5=>"1/3",   6=>"1/3", 7=>"1/3"},
                      :aircraft =>  { 1=>"-",     2=>"-",   3=>"-"}
                    }

    NAME = "Schwer Laser-Warfer"
    TYPE = '4'
    
    def initialize
      super(NAME, TYPE, COMBAT_VALUES)
    end

  end
end
