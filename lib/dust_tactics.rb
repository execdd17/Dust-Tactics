require 'ap'
require 'dust_tactics/board'
require 'dust_tactics/weapon_line'

# require all the files in the units directory
Dir["./lib/dust_tactics/units/**/*.rb"].each { |file| require file }
