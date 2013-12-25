require 'git'

module Services
  module Projects
    class UpdateTags < Services::Base
      def call(project)
        git = Git.open(project.local_path)
        # TODO: How to do this with the git-ruby gem?
        # https://github.com/schacon/ruby-git/issues/115
        system("cd #{project.local_path} && git fetch --tags")
        tags = git.tags.map(&:name)
        project.tags = tags
        project.save!
        project
      end
    end
  end
end
