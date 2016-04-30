module Docs
  class CreateGitFiles < Services::Base
    def call(id_or_object)
      doc = find_object(id_or_object)
      check_uniqueness doc.project.id
      git = Git.open(doc.project.local_path)
      git.checkout doc.tag
      FileUtils.rm_rf doc.local_git_path if File.exist?(doc.local_git_path)
      FileUtils.cp_r doc.project.local_path, doc.local_git_path
    end
  end
end
