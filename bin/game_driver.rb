$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'dust_tactics'

class GameDriver
  include DustTactics
  include DustTactics::Units

  ALL_INTERACTABLE_UNITS = [Blackhawk, HeavyLaserGrenadiers, Lara, Rhino]
  BOARD_MAX_X = 3
  BOARD_MAX_Y = 3

  #TODO: I HATE how a player has a board. It doesn't make any sense!
  def initialize
    @board = Board.new(BOARD_MAX_X, BOARD_MAX_Y)
    @player_one = Player.new("Alex", "good guys", @board)
    @player_two = Player.new("AI", "bad guys", @board)
  end

  def run
    deploy_cover

    @player_one.add_unit(ALL_INTERACTABLE_UNITS.sample.new)
    @player_two.add_unit(ALL_INTERACTABLE_UNITS.sample.new)

    player_one_can_act = @player_one.activatable_units.size > 0
    player_two_can_act = @player_two.activatable_units.size > 0

    while player_one_can_act or player_two_can_act
      if player_one_can_act and player_two_can_act
        handle_initiative
        turn_loop(@player_one)
        turn_loop(@player_two)
      elsif player_one_can_act
        turn_loop(@player_one)
      elsif player_two_can_act
        turn_loop(@player_two)
      else
        raise 'Oh god, this is a bug'
      end

      player_one_can_act = @player_one.activatable_units.size > 0
      player_two_can_act = @player_two.activatable_units.size > 0
    end
  end

  private

  def deploy_cover
    puts "Rolling for initiative..."
    handle_initiative

    puts "#{@player_one.name} wins the initiative"
    p "#{@player_one.name}, where should I deploy the soft cover unit (x,y)?: "
    # x,y = ARGF.readline.strip.split(',').map(&:to_i)
    # SoftCover.new.deploy(@board.space(x,y))
    SoftCover.new.deploy(@board.space(0,0))

    p "#{@player_two.name}, where should I deploy the soft cover unit (x,y)?: "
    # x,y = ARGF.readline.strip.split(',').map(&:to_i)
    # SoftCover.new.deploy(@board.space(x,y))
    SoftCover.new.deploy(@board.space(0,1))
  end

  def turn_loop(player)
    puts "#{player.name}, it's your turn!"
    puts "Available Units: [#{player.activatable_units.join(',')}]"
    p 'What unit do you want to activate (use index)?: '
    # index = ARGF.readline.strip.to_i
    index = 0
    unit = player.activatable_units[index]
    player.activate(unit)

    if unit.in_space?
      puts 'What will your first action be (1: MOVE, 2: ATTACK, 3: DO NOTHING)?:'
      action_type = ARGF.readline.strip.to_i
      case action_type
        when 1 then
          p 'Where do you want to move (x,y)?: '
          x,y = ARGF.readline.strip.split(',').map(&:to_i)
          player.move(@board.space(x,y))
        when 2 then
          p 'Where do you want to attack (x,y)?: '
          x,y = ARGF.readline.strip.split(',').map(&:to_i)
          player.attack(@board.space(x,y).non_cover, unit.weapon_lines)
        when 3 then
          player.do_nothing
      end
    else
      puts 'You must deploy this unit. Where should I put it?: '
      x,y = ARGF.readline.strip.split(',').map(&:to_i)
      player.deploy(@board.space(x,y))
    end

    @board.visual_aid
    puts "\n" << "*" * 100

    puts 'What will your second action be (1: MOVE, 2: ATTACK, 3: DO NOTHING)?:'
    action_type = ARGF.readline.strip.to_i
    case action_type
      when 1 then
        p 'Where do you want to move (x,y)?: '
        x,y = ARGF.readline.strip.split(',').map(&:to_i)
        player.move(@board.space(x,y))
      when 2 then
        p 'Where do you want to attack (x,y)?: '
        x,y = ARGF.readline.strip.split(',').map(&:to_i)
        player.attack(@board.space(x,y).non_cover, unit.weapon_lines)
      when 3 then
        player.do_nothing
    end

    @board.visual_aid
    puts "\n" << "*" * 100
    puts player.state
    puts player.ticks
    puts unit.activated?
    puts 'Your turn is over'
  end

  def handle_initiative
    winner = GameEngine.initiative @player_one, @player_two
    loser  = winner == @player_one ? @player_two : @player_one

    @player_one, @player_two = winner, loser
  end
end

GameDriver.new().run


# ## NOTE: you would do this "typical flow" for as long as either player has activatable units
# # typical flow for a turn
# me.activate(me.units.first)
# me.deploy( @board.space(0,0))
# me.move(@board.space(1,0))
#
# # typical flow for a turn
# ai.activate(ai.units.first)
# ai.deploy(@board.space(0,0))
# puts "#{ai.units.first} is attacking #{@board.space(1,0).non_cover}"
# ai.attack(@board.space(1,0).non_cover, ai.units.first.weapon_lines)
# ai.do_nothing
#
# # unless me.units.first.alive?
# #   puts "You killed #{me.units.first}"
# # end
#
# # Now there are no activatable units lets so we reset the round
# # NOTE: we need to call restart to restore ticks, so this would happen after every activation
# me.restart
# ai.restart
# me.reset_round
# ai.reset_round
#
# me.activate(me.units.first)
# puts "#{me.units.first} is attacking #{@board.space(0,0).non_cover}"
# me.attack(@board.space(0,0).non_cover, me.units.first.weapon_lines)
# b.visual_aid
