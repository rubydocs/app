module Docs
  class DeleteFiles < Baseline::Service
    def call(doc)
      check_uniqueness doc.id
      if File.exist?(doc.local_path)
        FileUtils.rm_rf doc.local_path
      end
      doc
    end
  end
end
