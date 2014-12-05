module Services
  module DocCollections
    class Find < Services::BaseFinder
      private def process(scope, conditions)
        conditions.each do |k, v|
          case k
          when :slug
            scope = scope.where(k => v)
          when :generated_at, :uploaded_at
            scope = if v == true
              scope.where("#{k} IS NOT NULL")
            else
              scope.where(k => v)
            end
          when :docs
            scope = scope
              .joins(:doc_collection_memberships)
              .where(doc_collection_memberships: { doc_id: v })
              .where(
                DocCollectionMembership
                  .where('doc_collection_id = doc_collections.id')
                  .where('doc_id NOT IN (?)', v)
                  .exists.not
              )
              .group('doc_collection_memberships.doc_collection_id, doc_collections.id')
              .having('COUNT(doc_collection_memberships.doc_id) = ?', v.size)
          else
            raise ArgumentError, "Unexpected condition: #{k}"
          end
        end
        scope
      end
    end
  end
end
