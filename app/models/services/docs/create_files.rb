require 'rdoc'
require 'sdoc'

module Services
  module Docs
    class CreateFiles < Services::Base
      FilesExistsError = Class.new(Error)
      CreatingInProgressError = Class.new(Error)

      def call(doc)
        @doc = doc
        guard_creating do
          git = Git.open(doc.project.local_path)
          git.checkout doc.tag
          rdoc = RDoc::RDoc.new
          args = [
            '--format=sdoc',
            '--github',
            '--line-numbers',
            "--title=#{doc.name}",
            "--output=#{doc.local_path}"
          ]
          %w(test example bin).each do |dir|
            args.push("--exclude=#{dir}") if File.exist?(doc.project.local_path.join(dir))
          end
          %w(.md .markdown .mdown .txt .rdoc).unshift(nil).each do |suffix|
            readme = "README#{suffix}"
            if File.exist?(doc.project.local_path.join(readme))
              args.push("--main=#{readme}")
              break
            end
          end
          args.push '.'
          git.chdir do
            rdoc.document args
          end
        end
        doc
      end

      private

      def guard_creating(&block)
        raise FilesExistsError, "Files for doc #{@doc.name} already exist." if File.exist?(@doc.local_path) && Dir[File.join(@doc.local_path, '*')].present?
        lock = @doc.project.local_path.join('.rubydocs-lock')
        raise CreatingInProgressError, "A doc for project #{@doc.project.name} is already being created." if File.exist?(lock)
        FileUtils.touch lock

        begin
          block.call
        ensure
          File.delete lock if File.exist?(lock)
        end
      end
    end
  end
end
