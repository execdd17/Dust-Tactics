# Raised when attempting to move a unit that isn't in a space
class NotInSpace < Exception; end

# Raised when attempting to attack a unit that is not in a space, or
# with an unsuppored weapon type
class InvalidAttack < Exception; end

module DustTactics::Interactable

  def move(end_space)
    raise NotInSpace, "#{self.class} isn't in a space!" unless in_space?

    @space.evict(:unit)
    end_space.occupy(self)
    @space = end_space
  end

  #TODO: Only attacking with one close combat weapon line when there are more 
  # available leads to a problem. The target is countering with everything
  # that it has, which means if this method is called again for the attacker's
  # remaining close combat weapon lines, the target will once again use all its
  # close combat weapon lines as a reponse!
  def attack(board, target, weapon_line)
    
    validate_attack(board, target, weapon_line)     # raise exceptions here

    attacker_dice = weapon_line.num_dice(target.type, target.armor)
    save_type     = get_save_type(target)           # hard, soft, none
    battle_report = {}                              # summary of all attacks
	
    case weapon_line.type
    when /\d/ then                                  # range attack
      attacker_outcome = GameEngine.resolve_attack(attacker_dice, save_type)
      target.take_damage(attacker_outcome[:net_hits])
      battle_report.merge!(:attacker => attacker_outcome)
    when 'C' then                                   # close combat attack
      save_type         = :none
      attacker_outcome  = GameEngine.resolve_attack(attacker_dice, save_type)
      target.take_damage(attacker_outcome[:net_hits])
      battle_report.merge!(:attacker => attacker_outcome)
      
      counter_weapons = target.weapon_lines.select { |wl| wl.close_combat? } 
      unless counter_weapons.empty? then
        counter_weapons.each do |wl|
          defender_dice     = wl.num_dice(self.type, self.armor)
          defender_outcome  = GameEngine.resolve_attack(defender_dice, save_type)
          self.take_damage(defender_outcome[:net_hits])
          battle_report.merge!(:defender => defender_outcome)
        end
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

  def get_save_type(target)
    if Units::HardCover === target.space.cover then
      save_type = :miss
    elsif Units::SoftCover === target.space.cover then
      save_type = :hit
    else 
      save_type = :none
    end
  end

  def validate_attack(board, target, weapon_line)
    raise InvalidAttack, "The attacker isn't in a space!" unless
      self.space and self.space.non_cover

    raise InvalidAttack, "The target isn't in a space!" unless 
      target.space and target.space.non_cover

    raise InvalidAttack, "#{weapon_line} is not in range to attack!" unless
      weapons_in_range(board, target, self.weapon_lines).include?(weapon_line)
  end

end
