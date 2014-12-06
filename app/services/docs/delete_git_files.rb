module Services
  module Docs
    class DeleteGitFiles < Services::Base
      def call(id_or_object)
        doc = find_object(id_or_object)
        check_uniqueness doc.id
        FileUtils.rm_rf doc.local_git_path if File.exist?(doc.local_git_path)
        doc
      end
    end
  end
end
