require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/dust_tactics'))

require 'dust_tactics'
include DustTactics

def rand_weapon_line(unit)
  unit.weapon_lines.sample
end

# Creates a new interactable unit at random
def rand_interactable_unit
  class_sym = interactable_units.shuffle.first
  Units.const_get(class_sym).new
end

# Returns a list of interactable units
def interactable_units
  Units.constants.select do |klass|
    Units.const_get(klass).included_modules.include?(Interactable)
  end
end

# Return the tuple [Attacker, Defender] for the given scenario type
# The units will already be deployed
def deployment_factory(board, scenario)                               
  case scenario                                                       
  when :close_combat then                                             
    units = [Units::Rhino.new, Units::Lara.new, 
             Units::HeavyLaserGrenadiers.new].shuffle
    cc_attacker = units.shift
    cc_defender = units.shift    
    
    cc_attacker.deploy(Space.new(0,0))                                
    cc_defender.deploy(Space.new(0,1))                                
                                                                      
    [cc_attacker, cc_defender]         
  when :ranged_combat then                                            
    ranged_attacker = [Units::Lara.new, Units::BlackHawk.new, 
                       Units::HeavyLaserGrenadiers.new].sample
    defender        = Units::Rhino.new    
    
    ranged_attacker.deploy(Space.new(0,0))                            
    defender.deploy(Space.new(0,1))                                   
                                                                      
    [ranged_attacker, defender]   
  when :random then                                                   
    attacker, defender = rand_interactable_unit, rand_interactable_unit
    
    rand_space1 =  board.rand_space()
    rand_space2 =  board.rand_space( [rand_space1] ) 
    
    attacker.deploy(rand_space1)                                      
    defender.deploy(rand_space2)                                      
    
    [attacker, defender]                    
  end                                                                 
end                                                                   

# The problem with doing it this way is the load order
# For example, class A needs class B in order to work, but
# class A is loaded first
#Dir["./lib/**/*.rb"].each do |f| 
#  puts "loading #{f}"
#  load f
#end
