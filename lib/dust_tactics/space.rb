require 'unit'

class IllegalEviction < Exception; end

module DustTactics
  class Space

    attr_reader :resident
  
    def occupy(resident)
      @resident = resident
    end

    def evict
      raise(IllegalEviction, "That's just not ethical") if empty?
      @resident = nil
    end

    def empty?
      @resident ? false : true
    end
  end
end
