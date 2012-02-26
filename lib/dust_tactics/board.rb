require 'space'

module DustTactics
  class Board

    attr_reader :grid

    def initialize(num_rows, num_columns)
      @grid = num_rows.times.inject(Array.new) do |row, row_index|
        row << num_columns.times.inject(Array.new) do |col, column_index|
          col << ::DustTactics::Space.new
        end
      end
    end

    # based off of http://www.oop.rwth-aachen.de/documents/oop-2007/sss-oop-2007.pdf
    # calculate the point value of every square in the grid, trace a path
    # by finding any set of decremental values from the end point to the start
    def shortest_path(start_pt, end_pt)
      problem_space = [[]]
      queue = [start_pt]

      begin
        begin 
          next_pt = queue.pop
        end while problem_space.include?(next_pt)
        
        problem_space << next_pt
        neighbors = neighbors(*next_pt)
        queue     += neighbors
      end while neighbors.include?(end_pt) == false 
      problem_space
    end
    
    # calculate the adjacent 4 points and remove any that are out of bounds
    # NOTE: should always return UP, DOWN, LEFT, RIGHT (minus the out of
    # bounds)
    def neighbors(x,y)
      puts "calling neighbors on #{x} #{y}"
      unchecked = [ [x-1,y], [x+1, y], [x,y-1], [x,y+1] ]
      unchecked.select do |neighbor|
          neighbor[0] >= 0 and neighbor[0] < @grid.length and
          neighbor[1] >= 0 and neighbor[1] < @grid.first.length
      end
    end

    def visual_aid
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
          printf(" | %2s,%-2s | ", row_index, col_index)
        end
        puts
      end
    end
  end

  b = Board.new 4,4
  b.shortest_path [0,0], [1,3]
end
