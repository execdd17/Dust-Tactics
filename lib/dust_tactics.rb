require 'ap'
require 'dust_tactics/board'
require 'dust_tactics/weapon_line'
require 'dust_tactics/dice_engine'
require 'dust_tactics/game_engine'
require 'dust_tactics/player'

# require all the files in the weapons directory
# NOTE: This must be loaded before units since they require weapons
Dir["./lib/dust_tactics/weapons/**/*.rb"].each { |file| require file }

# require all the files in the units directory
Dir["./lib/dust_tactics/units/**/*.rb"].each { |file| require file }
