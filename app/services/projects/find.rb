module Projects
  class Find < Services::Query
    private def process(scope, conditions)
      conditions.each do |k, v|
        case k
        when :name
          scope = scope.where(k => v)
        else
          raise ArgumentError, "Unexpected condition: #{k}"
        end
      end
      scope
    end
  end
end
