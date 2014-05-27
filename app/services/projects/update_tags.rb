require 'git'

module Services
  module Projects
    class UpdateTags < Services::Base
      check_uniqueness!

      def call(project_id)
        project = Services::Projects::Find.call(project_id).first
        raise Error, "Could not find project #{project_id}" if project.nil?
        git = Git.open(project.local_path)
        3.tries on: Git::GitExecuteError, delay: 1 do
          git.fetch 'origin', tags: true
        end
        tags = git.tags.each_with_object({}) do |tag, hash|
          hash[tag.name] = git.gcommit(tag.sha).date
        end
        # Sort tags by date
        tags = Hash[*tags.sort_by(&:last).reverse.flatten]
        project.tags = tags
        project.save!
        project
      end
    end
  end
end
