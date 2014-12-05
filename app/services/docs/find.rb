module Services
  module Docs
    class Find < Services::BaseFinder
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
end
