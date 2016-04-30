module Docs
  class DeleteFiles < Services::Base
    def call(id_or_object)
      doc = find_object(id_or_object)
      check_uniqueness doc.id
      FileUtils.rm_rf doc.local_path if File.exist?(doc.local_path)
      doc
    end
  end
end
