module Services
  module DocCollections
    class DeleteFiles < Services::Base
      def call(doc_collection)
        [doc_collection.local_path, doc_collection.zipfile].each do |path|
          [path, Rails.root.join('public', File.basename(path))].each do |p|
            FileUtils.rm_rf p
          end
        end
        doc_collection
      end
    end
  end
end
