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
            '--line-numbers',
            "--title=#{doc.name}",
            "--output=#{doc.local_path}",
            '.'
          ]
          %w(test example bin).each do |dir|
            args.unshift("--exclude=#{dir}") if File.exist?(doc.project.local_path.join(dir))
          end
          %w(.md .markdown .mdown .txt .rdoc).unshift(nil).each do |suffix|
            readme = "README#{suffix}"
            if File.exist?(doc.project.local_path.join(readme))
              args.unshift("--main=#{readme}")
              break
            end
          end
          Dir.chdir doc.project.local_path do
            rdoc.document args
          end
        end
        doc
      end

      private

      def creating_file
        @creating_file ||= @doc.project.local_path.join('.rubydocs-creating-files')
      end

      def guard_creating(&block)
        raise FilesExistsError, "Files for doc #{@doc.name} already exist." if File.exist?(@doc.local_path) && Dir[File.join(@doc.local_path, '*')].present?
        raise CreatingInProgressError, "A doc for project #{@doc.project.name} is already being created." if File.exist?(creating_file)
        FileUtils.touch creating_file

        begin
          block.call
        ensure
          File.delete creating_file if File.exist?(creating_file)
        end
      end
    end
  end
end
