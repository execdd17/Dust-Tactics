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
    def shortest_path(start_pt, end_pt)
      distance_hash = get_distance_hash(start_pt, end_pt)
      #trace_path(distance_hash)
    end

    # trace a path by finding any set of decremental values from the end point to the start
    def trace_path(distance_hash)
    
    end

    # calculate the distance value of adjacent squares; radiating outward via get_neighbors()
    def get_distance_hash(start_pt, end_pt)
      processed     = {}
      processed[0]  = [start_pt]
      distance      = 1
      neighbors     = get_neighbors(*start_pt)
      
      puts "start point #{start_pt.inspect} get_neighbors returned #{neighbors.inspect}"

      # NOTE: "unless neighbors.include?(end_pt)" DOES NOT WORK for some reason...
      while neighbors.include?(end_pt) == false
        processed[distance] = processed[distance] ? processed[distance] += neighbors : neighbors
        puts "processed a is #{processed.inspect}"
        
        # get the next batch of neighbors for each neighbor previously discovered
        neighbors = neighbors.inject(Array.new) do |memo, neighbor|
          puts "Running it on #{neighbor.inspect}"
          puts "memo was #{memo.inspect}"
          
          # fetch and filter
          memo += get_neighbors(*neighbor).reject do |neighbor| 
            memo.include?(neighbor) == true or 
              processed.each_value.any? { |point| point.include?(neighbor) }
          end

          puts "memo is now #{memo.inspect}"
          memo
        end
        distance += 1
      end
         
      puts "neighbors final value #{neighbors}"
      puts "end_point is #{end_pt}"
      processed[distance] = processed[distance] ? processed[distance] += neighbors : neighbors
      processed
    end
    
    # calculate the adjacent 4 points and remove any that are out of bounds
    # NOTE: should always return UP, DOWN, LEFT, RIGHT (minus the out of
    # bounds)
    def get_neighbors(x,y)
      unchecked = [ [x-1,y], [x+1, y], [x,y-1], [x,y+1] ]
      unchecked.select do |neighbor|
          neighbor[0] >= 0 and neighbor[0] < @grid.length and
          neighbor[1] >= 0 and neighbor[1] < @grid.first.length
      end
    end

    # simple visual of the x,y points for the board
    def visual_aid
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
          printf(" | %2s,%-2s | ", row_index, col_index)
        end
        puts
      end
    end
  end
end
