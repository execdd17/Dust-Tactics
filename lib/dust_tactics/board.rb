module DustTactics
  class Board

    attr_reader :grid, :num_rows, :num_cols

    def initialize(num_rows, num_columns)
      @num_rows, @num_cols = num_rows, num_columns

      @grid = num_rows.times.inject(Array.new) do |row, row_index|
        row << num_columns.times.inject(Array.new) do |col, column_index|
          col << ::DustTactics::Space.new(row_index, column_index)
        end
      end
    end

    # based off of http://www.oop.rwth-aachen.de/documents/oop-2007/sss-oop-2007.pdf
    def shortest_path(start_pt, end_pt)
      distance_hash = get_distance_hash(start_pt, end_pt)
      trace_path(distance_hash, end_pt)
    end

    # trace a path by finding any set of decremental values from the end point to the start
    def trace_path(distance_hash, end_pt)
      distance_hash.delete(distance_hash.length() -1)
      path = [end_pt]
      distance_hash.reverse_each do |distance, points|
        path.insert 0, points.detect { |point| adjacent?(point, path.first) }
      end
      path
    end

    # calculate the distance value of adjacent squares; radiating outward via get_neighbors()
    def get_distance_hash(start_pt, end_pt)
      processed     = {}
      processed[0]  = [start_pt]
      distance      = 1
      neighbors     = get_neighbors(*start_pt)

      # case where start_end end are equivalent
      return {0 => [start_pt]} if start_pt == end_pt 
      
      #puts "start point #{start_pt.inspect} get_neighbors returned #{neighbors.inspect}"

      # NOTE: "unless neighbors.include?(end_pt)" DOES NOT WORK for some reason...
      while neighbors.include?(end_pt) == false and processed.each_value.none? { |pts| pts == [] }
        processed[distance] = processed[distance] ? processed[distance] += neighbors : neighbors
        #puts "processed a is #{processed.inspect}"
        
        # get the next batch of neighbors for each neighbor previously discovered
        neighbors = neighbors.inject(Array.new) do |memo, neighbor|
          #puts "Running it on #{neighbor.inspect}"
          #puts "memo was #{memo.inspect}"
          
          # fetch and filter
          memo += get_neighbors(*neighbor).reject do |neighbor| 
            memo.include?(neighbor) == true or 
              processed.each_value.any? { |point| point.include?(neighbor) }
          end

          #puts "memo is now #{memo.inspect}"
          memo
        end
        distance += 1
      end
         
      #puts "neighbors final value #{neighbors}"
      #puts "end_point is #{end_pt}"
      return {} if processed.values.last == [] #the didn't find end_pt case
      processed[distance] = processed[distance] ? processed[distance] += neighbors : neighbors
      processed
    end

    # given two arrays in the form [x,y], determine if they are adjacent;
    # diagonals are not considered adjacent in the this implementation
    def adjacent?(start_pt, end_pt)
      up    = [start_pt.first - 1, start_pt.last] == end_pt
      down  = [start_pt.first + 1, start_pt.last] == end_pt
      left  = [start_pt.first, start_pt.last - 1] == end_pt
      right = [start_pt.first, start_pt.last + 1] == end_pt
      
      up or down or left or right
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

    def rand_space(blacklist=[])
      begin
        space = space(rand_point)
      end while blacklist.include?(space)
      space
    end

    # return a random [x,y] coordinate on the board
    def rand_point
      [ rand(0...(@num_rows)), rand(0...(@num_cols)) ]
    end

    # given an [x,y] coordinate or x,y as separate arguments, 
    # return the corresponding space
    def space(*args)
      x, y = *args.flatten
      @grid[x][y]
    end

    # simple visual of the x,y points for the board
    def visual_aid
      @grid.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
          current_space = space(row_index, col_index)

          if current_space.empty?
            printf(" | %9s,%-14s | ", row_index, col_index)
          else
            cover = current_space.cover ? current_space.cover.to_s : 'NoCover'
            unit  = current_space.non_cover ? current_space.non_cover.to_s : 'NoUnit'
            printf(" | %9s,%-14s | ", cover, unit)
          end
        end
        puts
      end
    end

    def valid_moves(start_pt, range)
      processed     = {}
      distance      = 1
      neighbors     = get_neighbors(*start_pt)

      while distance < range and processed.each_value.none? { |pts| pts == [] }
        processed[distance] = processed[distance] ? 
                              processed[distance] += neighbors : neighbors

        # get the next batch of neighbors for each neighbor previously discovered
        neighbors = neighbors.inject(Array.new) do |memo, neighbor|
          
          # fetch and filter
          memo += get_neighbors(*neighbor).reject do |neighbor| 
            local_dup  = memo.include?(neighbor) == true
            global_dup = processed.each_value.any? { |point| point.include?(neighbor) }
            equal_start_pt = neighbor == start_pt
            
            local_dup or global_dup or equal_start_pt
          end
          memo
        end
        distance += 1
      end
      processed[distance] = processed[distance] ? 
                            processed[distance] += neighbors : neighbors
      processed
    end
  end
end
