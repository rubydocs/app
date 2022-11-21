require 'git'

module Projects
  class Clone < Baseline::Service
    FilesExistsError = Class.new(Error)

    def call(project)
      if File.exist?(project.local_path) && Dir[File.join(project.local_path, '*')].present?
        raise FilesExistsError, "Files for project #{project.name} already exist."
      end
      dir = File.expand_path('..', project.local_path)
      Git.clone project.git, project.slug, path: dir
      project
    end
  end
end
