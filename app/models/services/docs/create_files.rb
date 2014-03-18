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
        end
        doc
      end

      private

      def guard_creating(&block)
        raise FilesExistsError, "Files for doc #{@doc.name} already exist." if File.exist?(@doc.local_path) && Dir[File.join(@doc.local_path, '*')].present?
        raise CreatingInProgressError, "A doc for project #{@doc.project.name} is already being created." if R.get(lock_key).present?
        R.set lock_key, Time.now

        begin
          block.call
        ensure
          R.del lock_key
        end
      end

      def lock_key
        [
          'doc_creating_lock',
          @doc.id
        ].join(':')
      end
    end
  end
end
