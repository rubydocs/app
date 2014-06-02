require 'sdoc/merge'
require 'zip'

module Services
  module DocCollections
    class CreateFiles < Services::Base
      FolderExistsError = Class.new(Error)

      check_uniqueness!

      def call(id_or_object)
        doc_collection = find_object(id_or_object)

        docs = Services::Docs::Find.call([], doc_collection: doc_collection)
        raise Error, "Doc collection #{doc_collection.name} has no docs." if docs.empty?
        raise FolderExistsError, "Folder for doc collection #{doc_collection.name} already exist." if File.exist?(doc_collection.local_path)

        # Merge or symlink docs
        if docs.size > 1
          sdoc_merge = SDoc::Merge.new
          sdoc_options = {
            title: doc_collection.name,
            op:    doc_collection.local_path,
            names: docs.map(&:name).join(',')
          }
          sdoc_args = sdoc_options.map do |k, v|
            "--#{k}=#{v}"
          end
          sdoc_merge.merge sdoc_args.concat(docs.map(&:local_path))
        else
          FileUtils.ln_s docs.first.local_path, doc_collection.local_path
        end

        # Create zip
        Dir.chdir doc_collection.local_path do
          Zip::File.open doc_collection.zipfile, Zip::File::CREATE do |zipfile|
            Dir['**/*'].each do |file|
              zipfile.add file, file
            end
          end
          FileUtils.chmod 0644, doc_collection.zipfile
        end

        # Symlink docs and zip to public folder
        [doc_collection.local_path, doc_collection.zipfile].each do |path|
          FileUtils.ln_s path, Rails.root.join('public', File.basename(path))
        end

        doc_collection
      end
    end
  end
end
