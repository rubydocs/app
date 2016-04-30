module Projects
  class Find < Services::Query
    private def process(scope, conditions)
      conditions.each do |k, v|
        raise ArgumentError, "Unexpected condition: #{k}"
      end
      scope
    end
  end
end
