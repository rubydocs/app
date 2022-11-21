require 'git'

module Projects
  class UpdateTags < Baseline::Service
    def call(project)
      check_uniqueness project.id
      git = Projects::OpenGit.call(project)
      tags = 10.tries on: [Git::GitExecuteError, Git::GitTagNameDoesNotExist], delay: 1 do
        git.tags.each_with_object({}) do |tag, hash|
          hash[tag.name] = git.gcommit(tag.sha).date
        end
      end
      # Sort tags by date
      tags = Hash[*tags.sort_by(&:last).reverse.flatten]
      project.tags = tags
      project.save!
      project
    end
  end
end
