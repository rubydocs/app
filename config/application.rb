require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

I18n.config.enforce_available_locales = false

Bundler.require(:default, Rails.env)

module RubyDocs
  class Application < Rails::Application
    ::REDIS_CONFIG = if Settings.redis?
      Settings.redis.to_hash
    else
      # Try to read from config/redis.yml
      YAML.load_file(Rails.root.join('config', 'redis.yml')).with_indifferent_access rescue nil
    end

    raise 'Redis config not found.' if REDIS_CONFIG.blank?

    ::REDIS_URL = "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}/#{REDIS_CONFIG[:db]}"

    require 'fakeredis' if %w(development test).include?(Rails.env)

    config.cache_store = :redis_store, REDIS_CONFIG.merge(namespace: 'cache', expires_in: 1.year)

    config.action_dispatch.rack_cache = %i(metastore entitystore).each_with_object({}) do |store, hash|
      hash[store] = "#{REDIS_URL}/rack_cache/#{store}"
    end

    config.autoload_paths += [
      config.root.join('app')
    ]

    config.assets.precompile += %w(
      show-doc-collection.css
    )

    config.secret_key_base = Settings.secret_key_base
  end
end

$DEBUG_RDOC = true
