module DustTactics::Interactable
  def move(end_space)
    @space.evict(:unit)
    end_space.occupy(self)
    @space = end_space
  end

  def attack
  end

end
