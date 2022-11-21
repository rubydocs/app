module Projects
  class ConvertTagsToVersions < Baseline::Service
    VERSION_REGEX = %r(
      \A
      (?:v|REL_|REV_)?
      (?<major>\d+)
      (?:
        [_.]
        (?<minor>\d+)
        (?:
          [_.]
          (?<patch>\d+)
          (?:
            [-_.]
            (?<meta>
              (alpha|beta|rc|preview|pre|p)?
              [_.]?
              \d*
            )
          )?
        )?
      )?
      \z
    )ix

    disable_call_logging

    def call(tags)
      tags.each_with_object({}) do |tag, hash|
        version_match = tag.match(VERSION_REGEX)
        hash[tag] = if version_match.nil?
          nil
        else
          [version_match[:major], version_match[:minor], version_match[:patch]].compact.join('.').tap do |version|
            if version_match[:meta].present?
              meta = version_match[:meta].downcase
              if meta =~ /\A\d+\z/
                meta.prepend 'p'
              end
              version << "-#{meta}"
            end
          end
        end
      end
    end
  end
end
