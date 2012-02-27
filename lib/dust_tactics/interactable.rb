module Interactable
  def move(board, start_pt, end_pt)
    board.space(start_pt).evict(:unit)
    board.space(end_pt).occupy(self)
  end

  def attack
  end

end
