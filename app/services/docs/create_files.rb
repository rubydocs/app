require 'rdoc'
require 'sdoc'

module Services
  module Docs
    class CreateFiles < Services::Base
      IncompleteError        = Class.new(Error)
      FilesExistsError       = Class.new(Error)
      GitFilesDontExistError = Class.new(Error)

      FILES_TO_CHECK = [
        SDoc::Merge::FLAG_FILE,
        RDoc::Generator::SDoc::TREE_FILE,
        RDoc::Generator::SDoc::SEARCH_INDEX_FILE
      ]

      def call(id_or_object)
        doc = find_object(id_or_object)
        check_uniqueness
        raise FilesExistsError, "Files for doc #{doc.name} already exist." if File.exist?(doc.local_path) && Dir[File.join(doc.local_path, '*')].present?
        raise GitFilesDontExistError, "Git files for doc #{doc.name} don't exist." unless File.exist?(doc.local_git_path) && Dir[File.join(doc.local_git_path, '*')].present?

        FileUtils.cd doc.local_git_path do
          # Create main file
          main_file = 'RUBYDOCS.rdoc'
          main_file_content = controller.render_to_string('docs/main', formats: :rdoc, locals: { doc: doc })
          File.write main_file, main_file_content

          # Set up options
          options = RDoc::Options.new
          options.setup_generator 'sdoc'
          options.github       = true
          options.line_numbers = true
          options.title        = doc.name
          options.op_dir       = doc.local_path
          options.main_page    = main_file
          %w(test example bin).each do |dir|
            if File.exist?(dir)
              options.exclude ||= []
              options.exclude << dir
            end
          end
          options.files = Dir['**/*.{c,rb,rdoc}']

          5.tries on: [Errno::EPIPE, IncompleteError] do
            RDoc::RDoc.new.document options

            unless FILES_TO_CHECK.each { |file| File.exists?(file) }
              FileUtils.rm_rf doc.local_path
              raise IncompleteError
            end
          end
        end
        doc
      end
    end
  end
end
