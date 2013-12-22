require 'rdoc'
require 'sdoc'

module Services
  module Docs
    class CreateFiles < Services::Base
      CreationInProgress = Class.new(Error)

      def call(doc)
        mark_project_as_creating doc.project do
          git = Git.open(doc.project.local_path)
          git.checkout doc.tag
          rdoc = RDoc::RDoc.new
          args = [
            '--format=sdoc',
            '--line-numbers',
            "--title=#{doc.project.name} #{doc.tag}",
            "--output=#{doc.local_path}",
            '--exclude=test',
            '--exclude=example',
            '--exclude=bin',
            doc.project.local_path.to_s
          ]
          %w(README README.md README.markdown README.mdown README.txt).each do |readme|
            if File.exist?(doc.project.local_path.join(readme))
              args.unshift("--main=#{readme}")
              break
            end
          end
          rdoc.document args
        end
        doc
      end

      private

      def mark_project_as_creating(project, &block)
        creating_file = project.local_path.join('.rubydocs-creating-files')
        raise CreationInProgress, "A doc for project #{project.name} is already being created." if File.exist?(creating_file)
        FileUtils.mkdir_p project.local_path
        FileUtils.touch creating_file

        block.call

        File.delete creating_file
      end
    end
  end
end
