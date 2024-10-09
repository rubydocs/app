require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RubyDocs
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib ignore: %w(assets tasks)

    config.time_zone = "Berlin"
    config.revision = begin
      ENV.fetch("HATCHBOX_REVISION")
    rescue KeyError
      `git rev-parse HEAD 2> /dev/null`.chomp
    end.presence or raise "Could not load revision."

    config.action_mailer.delivery_method = :postmark
    config.active_record.query_log_tags_enabled = true
    config.active_record.sqlite3_production_warning = false

    config.assets.excluded_paths.concat [
      Rails.root.join("app", "assets", "stylesheets")
    ]

    config.i18n.raise_on_missing_translations = true

    config.middleware.insert 0, Rack::Deflater

    Rails.application.routes.default_url_options =
      config.action_mailer.default_url_options = {
        host:     ENV.fetch("HOST"),
        protocol: "https"
      }

    if Rails.version >= "7.2"
      raise "this is not needed anymore, yjit should be enabled by default in rails 7.2."
    end
    config.after_initialize do
      RubyVM::YJIT.enable
    end
  end
end
