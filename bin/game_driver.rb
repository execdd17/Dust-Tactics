$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'dust_tactics'

include DustTactics
include DustTactics::Units

ALL_INTERACTABLE_UNITS = [Blackhawk, HeavyLaserGrenadiers, Lara, Rhino]
BOARD_MAX_X = 3
BOARD_MAX_Y = 3

b = Board.new(BOARD_MAX_X, BOARD_MAX_Y)
me = Player.new("Alex", "good guys", b)
ai = Player.new("John", "bad guys", b)

me.add_unit(ALL_INTERACTABLE_UNITS.sample.new)
me.add_unit(ALL_INTERACTABLE_UNITS.sample.new)
ai.add_unit(ALL_INTERACTABLE_UNITS.sample.new)
ai.add_unit(ALL_INTERACTABLE_UNITS.sample.new)

[me, ai].each { |player| player.add_unit(SoftCover.new) }

me.deploy_cover(me.units.last, b.space(1,0))
ai.deploy_cover(ai.units.last, b.space(0,0))
starting_player = GameEngine.initiative me, ai

## NOTE: you would do this "typical flow" for as long as either player has activatable units
# typical flow for a turn
me.activate(me.units.first)
me.deploy( b.space(0,0))
me.move(b.space(1,0))

# typical flow for a turn
ai.activate(ai.units.first)
ai.deploy(b.space(0,0))
puts "#{ai.units.first} is attacking #{b.space(1,0).non_cover}"
ai.attack(b.space(1,0).non_cover, ai.units.first.weapon_lines)
ai.do_nothing

# unless me.units.first.alive?
#   puts "You killed #{me.units.first}"
# end

# Now there are no activatable units lets so we reset the round
# NOTE: we need to call restart to restore ticks, so this would happen after every activation
me.restart
ai.restart
me.reset_round
ai.reset_round

me.activate(me.units.first)
puts "#{me.units.first} is attacking #{b.space(0,0).non_cover}"
me.attack(b.space(0,0).non_cover, me.units.first.weapon_lines)
b.visual_aid