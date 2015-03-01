# Raised when attempting to move a unit that isn't in a space
class NotInSpace < Exception; end

class DuplicateActivation < Exception; end
class DuplicateDeactivation < Exception; end

# Raised when attempting to attack a unit that is not in a space, or
# with an unsuppored weapon type
class InvalidAttack < Exception; end

module DustTactics::Interactable

  def activate
    raise DuplicateActivation, "#{self} was already activated" if @activated
    @activated = true
  end

  def deactivate
    raise DuplicateDeactivation, "#{self} was already deactivated" unless @activated
    @activated = false
  end

  def activated?
    @activated ||= false  # return false instead of nil when undefined
  end

  def move(end_space)
    raise NotInSpace, "#{self.class} isn't in a space!" unless in_space?

    @space.evict(:unit)
    end_space.occupy(self)
    @space = end_space
  end

  # NOTE: You should never call this function twice to attack the same target
  # in a single round. If you are going to attack a target with more than one
  # weapon line, then supply them all for a single call. If attacking with a
  # single weapon line, then pass in an array of size 1
  def attack(board, target, weapon_lines)
    
    save_type     = target.get_save_type            # hard, soft, none
    battle_report = {}                              # summary of all attacks
    cc_weapon_line_queue = Array.new
	
    weapon_lines.each do |weapon_line|
      validate_attack(board, target, weapon_line)     # raise exceptions here
      attacker_dice = weapon_line.num_dice(target.type, target.armor)

      case weapon_line.type
      when /\d/ then                                  # range attack
        attacker_outcome = DustTactics::GameEngine.resolve_attack(attacker_dice, save_type)
        target.take_damage(attacker_outcome[:net_hits])
        args          = [battle_report, attacker_outcome, :attacker]
        battle_report = DustTactics::GameEngine.combine_reports(*args)
      when 'C' then                                   # close combat attack
        cc_weapon_line_queue << weapon_line
      end
    end

    # perform 'simultaneous' close combat if such an attack occured
    if cc_weapon_line_queue.empty? == false and target.alive?
      cc_weapon_line_queue.each do |weapon_line| 
        attacker_dice = weapon_line.num_dice(target.type, target.armor)
        save_type         = :none
        attacker_outcome  = DustTactics::GameEngine.resolve_attack(attacker_dice, save_type)
        target.take_damage(attacker_outcome[:net_hits])
        
        args          = [battle_report, attacker_outcome, :attacker]
        battle_report = DustTactics::GameEngine.combine_reports(*args)
      end
        
      counter_weapons = target.weapon_lines.select { |wl| wl.close_combat? } 
      
      counter_weapons.each do |wl|
        defender_dice     = wl.num_dice(self.type, self.armor)
        defender_outcome  = DustTactics::GameEngine.resolve_attack(defender_dice, save_type)
        self.take_damage(defender_outcome[:net_hits])
      
        args          = battle_report, defender_outcome, :defender
        battle_report = DustTactics::GameEngine.combine_reports(*args)
      end
    end

    battle_report
  end
  
  def weapons_in_range(board, target, weapon_lines)
    dh = board.get_distance_hash(self.space.point, target.space.point) 
    distance_to_target = dh.sort.last.first

    weapon_lines.select do |wl|
      case wl.type
      when /\d/ then true if wl.type.to_i >= distance_to_target
      when 'C'  then true if 1            == distance_to_target
      else 
        raise InvalidAttack, "#{wl.type} is not a supported weapon type"
      end
    end
  end
  
  private

  # def get_save_type(target)
  #   raise InvalidAttack, "The target isn't in a space!" unless
  #     target.space and target.space.non_cover
  #
  #   if Units::HardCover === target.space.cover then
  #     :miss
  #   elsif Units::SoftCover === target.space.cover then
  #     :hit
  #   else
  #     :none
  #   end
  # end

  def validate_attack(board, target, weapon_line)
    raise InvalidAttack, "The attacker isn't in a space!" unless
      self.space and self.space.non_cover

    raise InvalidAttack, "#{weapon_line} is not in range to attack!" unless
      weapons_in_range(board, target, self.weapon_lines).include?(weapon_line)
  end
end
