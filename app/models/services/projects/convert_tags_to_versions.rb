module Services
  module Projects
    class ConvertTagsToVersions < Services::Base
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

      def call(tags)
        tags.each_with_object({}) do |tag, hash|
          version_match = tag.match(VERSION_REGEX)
          hash[tag] = if version_match.nil?
            nil
          else
            [version_match[:major], version_match[:minor], version_match[:patch]].compact.join('.').tap do |version|
              if version_match[:meta].present?
                meta = version_match[:meta].downcase
                meta.prepend 'p' if meta =~ /\A\d+\z/
                version << "-#{meta}"
              end
            end
          end
        end
      end
    end
  end
end
