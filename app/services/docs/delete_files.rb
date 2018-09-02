module Docs
  class DeleteFiles < Services::Base
    def call(id_or_object)
      doc = find_object(id_or_object)
      check_uniqueness doc.id
      if File.exist?(doc.local_path)
        FileUtils.rm_rf doc.local_path
      end
      doc
    end
  end
end
