require 'git'

module Services
  module Projects
    class Clone < Services::Base
      FolderExistsError = Class.new(Error)

      def call(project)
        raise FolderExistsError, "Folder #{project.local_path} already exists and is not empty." if File.exist?(project.local_path) && !Dir[File.join(project.local_path, '*')].empty?
      
        Git.clone project.git, project.slug, path: Project::PATH
        project
      end
    end
  end
end
