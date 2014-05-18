module Services
  module DocCollections
    class Find < Services::Base
      def call(ids, conditions = {})
        ids = Array(ids)
        scope = DocCollection.all
        scope = scope.where(id: ids) unless ids.empty?
        scope = scope.order("#{DocCollection.table_name}.id") unless conditions.key?(:order)
        conditions.each do |k, v|
          case k.to_sym
          when :slug
            scope = scope.where(k => v)
          when :docs
            # Not completely correct yet
            scope = scope
              .joins(:doc_collection_memberships)
              .where(doc_collection_memberships: { doc_id: v.map(&:id) })
              .group('doc_collections.id')
              .having("COUNT(doc_collection_memberships.id) = #{v.count}")
          else
            raise ArgumentError, "Unexpected condition: #{k}"
          end
        end
        # TODO: Do this as a scope:
        # http://stackoverflow.com/questions/22489433/how-to-fetch-records-with-exactly-specified-has-many-through-records
        if conditions.has_key?(:docs)
          scope = scope.select do |doc_collection|
            doc_collection.docs.pluck(:id).sort == conditions[:docs].map(&:id).sort
          end
        end
        scope
      end
    end
  end
end
