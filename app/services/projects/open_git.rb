require 'git'

module Projects
  class OpenGit < Baseline::Service
    def call(project)
      if File.directory?(project.local_path)
        Git.open(project.local_path)
      else
        Git.clone(project.git, project.slug,
          path:      project.local_path.dirname,
          depth:     1,
          recursive: true
        )
      end.tap do |git|
        git.fetch 'origin', tags: true
      end
    end
  end
end
