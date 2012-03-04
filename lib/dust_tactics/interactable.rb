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

  def attack(board, target, weapon_line)
    raise InvalidAttack, "The attacker isn't in a space!" unless
      self.space and self.space.non_cover

    raise InvalidAttack, "The target isn't in a space!" unless 
      target.space and target.space.non_cover
      
    weapons =  weapons_in_range(board, target, self.weapon_lines)
    
    if weapons.include?(weapon_line) then
      case weapon_line.type
      when /\d/ then              # range attack
      when 'C' then               # close combat attack
      end
    else
      raise InvalidAttack, "#{weapon_line} is not in range to attack!"
    end
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

end
