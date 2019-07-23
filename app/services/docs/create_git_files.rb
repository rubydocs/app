module Docs
  class CreateGitFiles < Services::Base
    def call(doc)
      check_uniqueness doc.project.id
      git = Projects::OpenGit.call(doc.project)
      git.checkout doc.tag
      if File.exist?(doc.local_git_path)
        FileUtils.rm_rf doc.local_git_path
      else
        FileUtils.mkdir_p doc.local_git_path.dirname
      end
      FileUtils.cp_r doc.project.local_path, doc.local_git_path
    end
  end
end
