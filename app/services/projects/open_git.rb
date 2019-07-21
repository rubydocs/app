require 'git'

module Projects
  class OpenGit < Services::Base
    def call(project)
      unless File.directory?(project.local_path)
        Git.clone(project.git, project.slug, path: project.local_path)
      end
      Git.open(project.local_path)
    end
  end
end
