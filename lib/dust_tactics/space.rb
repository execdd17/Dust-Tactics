require 'unit'

class IllegalEviction     < Exception; end
class SpaceOccupied       < Exception; end
class CoverExists         < Exception; end
class DuplicateOccupation < Exception; end

module DustTactics
  class Space

    attr_reader :cover, :non_cover

    def initialize
      @cover = @non_cover = nil
    end
 
    def occupy(resident)
      if not empty?
        if @cover and not resident.cover? then  
          @non_cover  = resident  #place new unit with cover
        elsif @non_cover and resident.cover? then 
          @cover      = resident  #place new cover with unit       
        elsif @cover and resident.cover? then
          raise CoverExists       # cover on cover
        elsif @non_cover and not resident.cover? then
          raise SpaceOccupied     # non_cover on non_cover
        end
      else 
        resident.cover? ? @cover = resident : @non_cover = resident
      end
    end

    def evict(type=:all)
      raise(IllegalEviction, "That's just not ethical") if empty?
      case type
      when :cover then
        raise IllegalEviction unless @cover
        @cover      = nil
      when :unit then
        raise IllegalEviction unless @non_cover
        @non_cover  = nil
      when :all then
        @cover = @non_cover = nil
      end
    end

    def empty?
      not (@cover or @non_cover)
    end
  end
end
