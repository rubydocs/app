module Services
  module Projects
    class ConvertTagToVersion < Services::Base
      VERSION_REGEX = %r(
        \A
        v?
        (?<major>\d+)
        (?:
          [_.]
          (?<minor>\d+)
          (?:
            [_.]
            (?<patch>\d+)
            (?:
              [_.]
              (?<meta>
                (beta|rc|preview|pre|p)?
                [_.]?
                \d*
              )
            )?
          )?
        )?
        \z
      )ix

      def call(tag)
        version_match = tag.match(VERSION_REGEX)
        raise Error, "Could not convert tag #{tag} to version." if version_match.nil?
        version = [version_match[:major], version_match[:minor], version_match[:patch]].compact.join('.')
        if version_match[:meta].present?
          meta = version_match[:meta].downcase
          meta.prepend 'p' if meta =~ /\A\d+\z/
          version << "-#{meta}"
        end
        version
      end
    end
  end
end
