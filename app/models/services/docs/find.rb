module Services
  module Docs
    class Find < Services::Base
      def call(ids, conditions = {})
        ids = Array(ids)
        scope = Doc.all
        scope = scope.where(id: ids) unless ids.empty?
        scope = scope.order("#{Doc.table_name}.id") unless conditions.key?(:order)
        conditions.each do |k, v|
          case k.to_sym
          when :project_id, :tag
            scope = scope.where(k => v)
          when :doc_collection
            scope = v.docs.merge(scope)
          else
            raise ArgumentError, "Unexpected condition: #{k}"
          end
        end
        scope
      end
    end
  end
end
