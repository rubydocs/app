require 'rdoc'
require 'sdoc'

module Services
  module Docs
    class CreateFiles < Services::Base
      FolderExistsError = Class.new(Error)

      def call(doc)
        raise FolderExistsError, "Folder #{doc.local_path} already exists and is not empty." if File.exist?(doc.local_path) && !Dir[File.join(doc.local_path, '*')].empty?
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
        doc
      end
    end
  end
end
