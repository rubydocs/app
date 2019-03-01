module DocCollections
  class Find < Services::Query
    TIMESTAMP_CONDITIONS = %i(created updated generated uploaded).product(%i(before after)).map do |timestamp, modifier|
      [timestamp, modifier].join('_').to_sym
    end

    private def process(scope, condition, value)
      case condition
      when :slug
        scope.where(condition => value)
      when :generated_at, :uploaded_at
        if value == true
          scope.where("doc_collections.#{condition} IS NOT NULL")
        else
          scope.where(condition => value)
        end
      when *TIMESTAMP_CONDITIONS
        timestamp, modifier = condition.to_s.split('_')
        scope.where("doc_collections.#{timestamp}_at #{modifier == 'before' ? '<' : '>'} ?", value)
      when :docs
        scope
          .joins(:doc_collection_memberships)
          .where(doc_collection_memberships: { doc_id: value })
          .where(
            DocCollectionMembership
              .where('doc_collection_id = doc_collections.id')
              .where('doc_id NOT IN (?)', value)
              .exists.not
          )
          .group('doc_collection_memberships.doc_collection_id, doc_collections.id')
          .having('COUNT(doc_collection_memberships.doc_id) = ?', value.size)
      when /\A(.+)_not\z/
        Array(value).each do |value|
          scope = scope.where(value.nil? ? "doc_collections.#{$1} IS NOT NULL" : ["doc_collections.#{$1} != ?", value])
        end
        scope
      when :only_one_doc
        ids = DocCollection.joins(:docs).group('doc_collections.id').having('COUNT(docs.id) = 1')
        if value
          scope.where(id: ids)
        else
          scope.where.not(id: ids)
        end
      end
    end
  end
end
