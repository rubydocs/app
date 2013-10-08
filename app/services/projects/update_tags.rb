require 'git'

module Services
  module Projects
    class UpdateTags < Services::Base
      def call(id)
        project = Project.find(id)
        git = Git.open(project.git_path)
        git.pull
        tags = git.tags.map(&:name)
        project.tags = tags
        project.save!
        project
      end
    end
  end
end
