module DocGenerators
  module Sdoc
    class GetVersion < Baseline::Service
      def call
        # TODO: Jeez, this is ugly! Isn't there an easier way
        # to get the version and SHA of the sdoc dependency?
        sdoc_version = `bundle list | grep sdoc`[/\(([^\)]+)/, 1]
        "sdoc #{sdoc_version}"
      end
    end
  end
end
