require 'sdoc/merge'
require 'zip'

module DocCollections
  class CreateFiles < Baseline::Service
    FolderExistsError = Class.new(Error)

    def call(doc_collection)
      check_uniqueness doc_collection.id

      if File.exist?(doc_collection.local_path)
        raise FolderExistsError, "Folder for doc collection #{doc_collection.id} (#{doc_collection}) already exist."
      end

      docs = Docs::Find.call(doc_collection: doc_collection)
      if docs.empty?
        raise Error, "Doc collection #{doc_collection.id} (#{doc_collection}) has no docs."
      end

      if docs.size == 1
        # Copy docs
        FileUtils.mkdir_p doc_collection.local_path.dirname
        FileUtils.cp_r docs.first.local_path, doc_collection.local_path
      else
        # Merge docs
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
      end

      # Create zip
      # Dir.chdir doc_collection.local_path do
      #   Zip::File.open doc_collection.zipfile, Zip::File::CREATE do |zipfile|
      #     Dir['**/*'].each do |file|
      #       zipfile.add file, file
      #     end
      #   end
      #   FileUtils.chmod 0644, doc_collection.zipfile
      # end

      doc_collection
    end
  end
end
