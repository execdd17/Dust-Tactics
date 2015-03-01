module DustTactics
  module Utils
    module NamespaceStripper

      ## taken from ActiveSupport::Inflector.demodulize
      def demodulize
        path = self.class.name
        if i = path.rindex('::')
          path[(i+2)..-1]
        else
          path
        end
      end
    end
  end
end