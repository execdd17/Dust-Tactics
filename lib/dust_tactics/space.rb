require 'unit'

class IllegalEviction     < Exception; end
class SpaceOccupied       < Exception; end
class CoverExists         < Exception; end
class DuplicateOccupation < Exception; end

module DustTactics
  class Space

    attr_reader :resident

    def initialize
      @resident = []
    end
 
    def occupy(resident)
      if not empty? and @resident.length < 2 then
        if @resident.first == resident then
          raise DuplicateOccupation
        elsif @resident.first.cover? and not resident.cover? then
          @resident.insert(1, resident) #non-cover is index 1
        elsif not @resident.first.cover? and resident.cover? then
          @resident.insert(0, resident) #cover is index 0
        elsif @resident.first.cover? and resident.cover? then
          raise CoverExists
        elsif not @resident.first.cover? and not resident.cover? then
          raise SpaceOccupied
        end
      else 
        @resident = [resident]
      end
    end

    def evict(type=:all)
      raise(IllegalEviction, "That's just not ethical") if empty?
      case type
      when :cover then
        raise IllegalEviction unless @resident.one? { |unit| unit.cover? }
        @resident.delete @resident.first
      when :unit then
        raise IllegalEviction unless @resident.one? { |unit| not unit.cover? }
        @resident.delete @resident.last
      when :all then
        @resident.clear
      end
    end

    def empty?
      @resident.empty? ? true : false
    end
  end
end
