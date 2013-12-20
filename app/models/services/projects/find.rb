module Services
  module Projects
    class Find < Services::Base
      def call(ids, conditions = {})
        ids = Array(ids)
        scope = Project.all
        scope = scope.where(id: ids) unless ids.empty?
        scope = scope.order("#{Project.table_name}.id") unless conditions.key?(:order)
        conditions.each do |k, v|
          raise ArgumentError, "Unexpected condition: #{k}"
        end
        scope
      end
    end
  end
end
