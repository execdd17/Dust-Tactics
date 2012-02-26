module DustTactics
  class Board

    attr_reader :grid

    def initialize(num_rows, num_columns)
      @grid = num_rows.times.inject(Array.new) do |memo, row|
        num_columns.times.inject(memo) do |memo2, column|
          memo2 << Space.new
        end
      end
    end

  end
end
