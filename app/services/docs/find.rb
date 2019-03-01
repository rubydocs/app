module Docs
  class Find < Services::Query
    convert_condition_objects_to_ids :project

    private def process(scope, condition, value)
      case condition
      when :project_id, :tag, :slug
        scope.where(condition => value)
      when :doc_collection
        scope.merge value.docs
      end
    end
  end
end
