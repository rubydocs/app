module Docs
  class DeleteGitFiles < Baseline::Service
    def call(doc)
      check_uniqueness doc.id
      if File.exist?(doc.local_git_path)
        FileUtils.rm_rf doc.local_git_path
      end
      doc
    end
  end
end
