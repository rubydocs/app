require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module RubyDocs
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.assets.precompile += %w(show-doc-collection.css)

    raise 'Redis settings not found.' unless Settings.redis?

    config.cache_store = :redis_store, Settings.redis.to_hash.merge(namespace: 'cache', expires_in: 1.year)

    redis_url = "redis://#{Settings.redis.host}:#{Settings.redis.port}/#{Settings.redis.db}"
    config.action_dispatch.rack_cache = {
      metastore:   "#{redis_url}/rack_cache/metastore",
      entitystore: "#{redis_url}/rack_cache/entitystore"
    }
  end
end

$DEBUG_RDOC = true
