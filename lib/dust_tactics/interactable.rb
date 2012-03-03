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

  def attack(unit, space, weapon_line)
    raise InvalidAttack, "The attacker isn't in a space!" unless
      self.space and self.space.non_cover

    raise InvalidAttack, "The target isn't in a space!" unless 
      space and space.non_cover
    
    case weapon_line.type
    when /\d/ then              # range attack
    when 'C' then               # close combat attack
    else 
      raise InvalidAttack, "#{weapon_line.type} is not a supported weapon type"
    end
  end

end
