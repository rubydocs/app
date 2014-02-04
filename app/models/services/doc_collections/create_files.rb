require 'sdoc/merge'

module Services
  module DocCollections
    class CreateFiles < Services::Base
      FolderExistsError = Class.new(Error)

      def call(doc_collection)
        docs = Services::Docs::Find.call([], doc_collection: doc_collection)
        raise Error, "Doc collection #{doc_collection.name} has no docs." if docs.empty?
        raise FolderExistsError, "Folder for doc collection #{doc_collection.name} already exist." if File.exist?(doc_collection.local_path)

        sdoc_merge = SDoc::Merge.new
        args = [
          "--title=#{doc_collection.name}",
          "--op=#{doc_collection.local_path}",
          "--names=#{docs.map(&:name).join(',')}",
          *docs.map(&:local_path)
        ]
        sdoc_merge.merge args

        doc_collection
      end
    end
  end
end
