require 'awesome_print'

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))             
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib/dust_tactics'))

require 'dust_tactics/utils/utils'
require 'dust_tactics/board'
require 'dust_tactics/space'
require 'dust_tactics/weapon_line'
require 'dust_tactics/weapons/weapons'
require 'dust_tactics/dice_engine'
require 'dust_tactics/game_engine'
require 'dust_tactics/player'
require 'dust_tactics/interactable'
require 'dust_tactics/unit'
require 'dust_tactics/units/units'