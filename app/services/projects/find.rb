module Services
  module Projects
    class Find < Services::BaseFinder
      private def process(scope, conditions)
        conditions.each do |k, v|
          raise ArgumentError, "Unexpected condition: #{k}"
        end
        scope
      end
    end
  end
end
