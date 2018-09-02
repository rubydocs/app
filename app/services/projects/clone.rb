require 'git'

module Projects
  class Clone < Services::Base
    FilesExistsError = Class.new(Error)

    def call(id_or_object)
      project = find_object(id_or_object)
      if File.exist?(project.local_path) && Dir[File.join(project.local_path, '*')].present?
        raise FilesExistsError, "Files for project #{project.name} already exist."
      end
      dir = File.expand_path('..', project.local_path)
      Git.clone project.git, project.slug, path: dir
      project
    end
  end
end
