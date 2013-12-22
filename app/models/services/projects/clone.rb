require 'git'

module Services
  module Projects
    class Clone < Services::Base
      FolderExistsError = Class.new(Error)

      def call(project)
        raise FolderExistsError, "Folder #{project.local_path} already exists and is not empty." if File.exist?(project.local_path) && Dir[File.join(project.local_path, '*')].present?
        dir = File.expand_path('..', project.local_path)
        Git.clone project.git, project.slug, path: dir
        project
      end
    end
  end
end
