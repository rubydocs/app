require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

I18n.config.enforce_available_locales = false

Bundler.require(:default, Rails.env)

module RubyDocs
  class Application < Rails::Application
    ::REDIS_CONFIG = case
    when File.exist?(redis_config = Rails.root.join('config', 'redis.yml'))
      YAML.load_file(redis_config).with_indifferent_access
    when Settings.redis?
      Settings.redis.to_hash
    else
      raise 'Redis config not found.'
    end

    redis_url_auth = if REDIS_CONFIG.has_key?(:username) || REDIS_CONFIG.has_key?(:password)
      [REDIS_CONFIG[:username], REDIS_CONFIG[:password]].join(':')
    end
    ::REDIS_URL = "redis://#{redis_url_auth + '@' if redis_url_auth}#{REDIS_CONFIG.fetch(:host)}:#{REDIS_CONFIG.fetch(:port)}/#{REDIS_CONFIG.fetch(:db)}"

    require 'fakeredis' if %w(development test).include?(Rails.env)

    config.cache_store = :readthis_store, {
      namespace:  'cache',
      expires_in: 1.month.to_i,
      redis: {
        url:      REDIS_URL,
        driver:   :hiredis
      }
    }

    config.action_dispatch.rack_cache = %i(metastore entitystore).each_with_object({}) do |store, hash|
      hash[store] = "#{REDIS_URL}/rack_cache/#{store}"
    end

    config.assets.precompile += %w(
      show-doc-collection.css
    )

    config.secret_key_base = Settings.secret_key_base

    config.i18n.enforce_available_locales = false
  end
end
