require 'ap'
require 'dust_tactics/board'
require 'dust_tactics/weapon_line'
require 'dust_tactics/dice_engine.rb'

# require all the files in the units directory
Dir["./lib/dust_tactics/units/**/*.rb"].each { |file| require file }
