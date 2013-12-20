require 'git'

module Services
  module Projects
    class UpdateTags < Services::Base
      def call(project)
        git = Git.open(project.local_path)
        # TODO: Do we need to fetch the remote to get the current list of tags?
        # git.remote('origin').fetch
        tags = git.tags.map(&:name)
        project.tags = tags
        project.save!
        project
      end
    end
  end
end
