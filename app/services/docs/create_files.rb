require 'rdoc'
require 'sdoc'

module Services
  module Docs
    class CreateFiles < Services::Base
      FilesExistsError = Class.new(Error)

      def call(id_or_object)
        doc = find_object(id_or_object)
        check_uniqueness doc.project.id
        raise FilesExistsError, "Files for doc #{doc.name} already exist." if File.exist?(doc.local_path) && Dir[File.join(doc.local_path, '*')].present?

        git = Git.open(doc.project.local_path)
        git.checkout doc.tag

        git.chdir do
          # Create main file
          main_file = 'RUBYDOCS.rdoc'
          main_file_content = controller.render_to_string('docs/main', formats: :rdoc, locals: { doc: doc })
          File.write(main_file, main_file_content)

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

          # Generate
          RDoc::RDoc.new.document options
        end
        doc
      end
    end
  end
end
