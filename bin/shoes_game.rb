$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# require 'dust_tactics'

class ShoesGame
  # a hack to hopefully not break this code I found
  MULTIPLYER    = 1.5

  PIECE_WIDTH   = 62 * MULTIPLYER
  PIECE_HEIGHT  = 62 * MULTIPLYER
  TOP_OFFSET    = 15 * MULTIPLYER
  LEFT_OFFSET   = 12 * MULTIPLYER

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
    # @app.clear do
      # @app.stack :margin => 10 do

        @app.fill @app.rgb(0, 0, 0, 0.0)
        @app.rect :left => 0, :top => 0, :width => 495, :height => (495 * MULTIPLYER).round
        @app.background '/home/alex/git_repos/Dust-Tactics/assets/CrackedEarth.jpg', height: (495 * MULTIPLYER).round, width: (495 * MULTIPLYER).round

        @board.each_with_index do |col, col_index|
          col.each_with_index do |cell, row_index|
            left, top = left_top_corner_of_piece(col_index, row_index)
            left = left - LEFT_OFFSET
            top = top - TOP_OFFSET
            # @app.fill @app.rgb(0, 440, 0, 90)
            # @app.strokewidth 1
            @app.stroke @app.rgb(0, 0, 0, 0.85)
            @app.strokewidth 1
            @app.nofill
            @app.rect :left => left, :top => top, :width => PIECE_WIDTH, :height => PIECE_HEIGHT

            # if cell != 0
              # @app.strokewidth 0
              # @app.fill (cell == 1 ? @app.rgb(100,100,100) : @app.rgb(155,155,155))
              # @app.oval(left+3, top+4, PIECE_WIDTH-10, PIECE_HEIGHT-10)

              # @app.fill (cell == 1 ? @app.black : @app.white)
              # @app.oval(left+5, top+5, PIECE_WIDTH-10, PIECE_HEIGHT-10)
            # end
          end
        end
      # end
    # end
  end

  def left_top_corner_of_piece(a,b)
    [(a*PIECE_WIDTH+LEFT_OFFSET), (b*PIECE_HEIGHT+TOP_OFFSET)]
    # [(a*PIECE_WIDTH+LEFT_OFFSET), (b*PIECE_HEIGHT)]
  end

  def right_bottom_corner_of_piece(a,b)
    left_top_corner_of_piece(a,b).map { |coord| coord + PIECE_WIDTH }
  end

  def find_piece(x,y)
    @board.each_with_index { |row_array, row|
      row_array.each_with_index { |col_array, col|
        left, top = left_top_corner_of_piece(col, row).map { |i| i - 5}
        right, bottom = right_bottom_corner_of_piece(col, row).map { |i| i -5 }
        return [col, row] if x >= left && x <= right && y >= top && y <= bottom
      }
    }
    return false
  end
end


Shoes.app :width => 1500, :height => 750 do
  game = ShoesGame.new(self)
  @available_actions = []

  flow width: '100%' do

    stack width: '50%' do
      game.draw_board
    end

    flow width: '50%' do
      flow width: '100%' do
        tagline strong('Current Action: ')
        @instruction = tagline "Do something..."
      end

      # @instruction.replace 'dfsfds'

      flow width: '100%' do
        tagline 'Your Units: '
        button "RHINO"
        button "LARA"
        button "BLACKHAWK"
      end

      stack width: '100%' do
        tagline 'Game info section'
      end

      stack width: '100%' do
        tagline 'Card info section'
      end
    end
  end

  click do |button, x, y|
    if coords = game.find_piece(x,y)
      puts "you clicked array indexes [#{coords.first}][#{coords.last}]"
    else
      puts 'you clicked an invalid space'
    end
  end
end