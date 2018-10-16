module Docs
  class Find < Services::Query
    convert_condition_objects_to_ids :project

    private def process(scope, conditions)
      conditions.each do |k, v|
        case k
        when :project_id, :tag, :slug
          scope = scope.where(k => v)
        when :doc_collection
          scope.merge! v.docs
        else
          raise ArgumentError, "Unexpected condition: #{k}"
        end
      end
      scope
    end
  end
end
