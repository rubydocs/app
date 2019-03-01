module Projects
  class Find < Services::Query
    private def process(scope, condition, value)
      case condition
      when :name
        scope.where(condition => value)
      end
    end
  end
end
