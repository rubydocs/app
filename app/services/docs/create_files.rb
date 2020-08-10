require 'rdoc'
require 'sdoc/merge'
require 'render_anywhere'

module Docs
  class CreateFiles < Services::Base
    include RenderAnywhere

    IncompleteError        = Class.new(Error)
    FilesExistsError       = Class.new(Error)
    GitFilesDontExistError = Class.new(Error)

    FILES_TO_CHECK = [
      SDoc::Merge::FLAG_FILE,
      RDoc::Generator::SDoc::TREE_FILE,
      RDoc::Generator::SDoc::SEARCH_INDEX_FILE
    ]

    def call(doc)
      check_uniqueness
      if File.exist?(doc.local_path)
        raise FilesExistsError, "Files for doc #{doc.name} already exist."
      end
      unless File.exist?(doc.local_git_path)
        raise GitFilesDontExistError, "Git files for doc #{doc.name} don't exist."
      end

      FileUtils.cd doc.local_git_path do
        # Create main file
        main_file = 'RUBYDOCS.rdoc'
        main_file_content = render('docs/main', formats: :rdoc, locals: { doc: doc }, layout: false)
        File.write main_file, main_file_content

        # Set up options
        options = RDoc::Options.new
        options.setup_generator 'sdoc'
        options.github       = true
        options.line_numbers = true
        options.title        = doc.name
        options.op_dir       = doc.local_path
        options.main_page    = main_file
        options.exclude      = %w(test example bin).select(&File.method(:exist?)).map { |dir| "\\b#{dir}\/" }
        options.files        = Dir['**/*.{c,rb,rdoc}']
        options.visibility   = :private

        5.tries on: [Errno::EPIPE, IncompleteError] do
          begin
            RDoc::RDoc.new.document options
          rescue RDoc::Error
            fail "Error creating files for doc #{doc.id} (#{doc})."
          end

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
