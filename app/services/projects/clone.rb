require 'git'

module Services
  module Projects
    class Clone < Services::Base
      FilesExistsError = Class.new(Error)

      def call(project)
        raise FilesExistsError, "Files for project #{project.name} already exist." if File.exist?(project.local_path) && Dir[File.join(project.local_path, '*')].present?
        dir = File.expand_path('..', project.local_path)
        Git.clone project.git, project.slug, path: dir
        project
      end
    end
  end
end
