$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# require 'dust_tactics'

class ShoesGame
  PIECE_WIDTH   = 62
  PIECE_HEIGHT  = 62
  TOP_OFFSET    = 47
  LEFT_OFFSET   = 12

  BOARD_SIZE    = [8,8]

  def initialize(app)
    @app           = app
    @board_history = []
    @board         = new_board
  end

  # Build the array for the board, with zero-based arrays.
  def new_board
    Array.new(BOARD_SIZE[0]) do # build each cols L to R
      Array.new(BOARD_SIZE[1]) do # insert cells in each col
        0
      end
    end
  end

  def draw_board
    @app.clear do
      @app.background @app.black

      @app.stack :margin => 10 do
        @app.fill @app.rgb(0, 190, 0)
        @app.rect :left => 0, :top => 0, :width => 495, :height => 495

        @board.each_with_index do |col, col_index|
          col.each_with_index do |cell, row_index|
            left, top = left_top_corner_of_piece(col_index, row_index)
            left = left - LEFT_OFFSET
            top = top - TOP_OFFSET
            @app.fill @app.rgb(0, 440, 0, 90)
            @app.strokewidth 1
            @app.stroke @app.rgb(0, 100, 0)
            @app.rect :left => left, :top => top, :width => PIECE_WIDTH, :height => PIECE_HEIGHT

            if cell != 0
              @app.strokewidth 0
              @app.fill (cell == 1 ? @app.rgb(100,100,100) : @app.rgb(155,155,155))
              @app.oval(left+3, top+4, PIECE_WIDTH-10, PIECE_HEIGHT-10)

              @app.fill (cell == 1 ? @app.black : @app.white)
              @app.oval(left+5, top+5, PIECE_WIDTH-10, PIECE_HEIGHT-10)
            end
          end
        end
      end
    end
  end

  def left_top_corner_of_piece(a,b)
    [(a*PIECE_WIDTH+LEFT_OFFSET), (b*PIECE_HEIGHT+TOP_OFFSET)]
  end

  def right_bottom_corner_of_piece(a,b)
    left_top_corner_of_piece(a,b).map { |coord| coord + PIECE_WIDTH }
  end
end


Shoes.app :width => 520, :height => 600 do
  game = ShoesGame.new(self)

  game.draw_board
end
