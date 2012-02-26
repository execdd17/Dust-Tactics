module DustTactics
  class Board

    attr_reader :grid

    def initialize(num_rows, num_columns)
      @grid = num_rows.times.inject(Array.new) do |memo, row|
        new_column = Array.new
        num_columns.times.inject(memo) do |memo2, column|
          memo2 << (new_column << Space.new)
        end
      end
    end

    def shortest_path(start_pt, end_pt)
      values = @grid.inject(0) do |memo, row|
        puts "row #{row} ri #{memo}"
        row.length.times.each_with_index.map do |col, col_index|
           col = memo + col_index
        end
      end
    end
  end
end
