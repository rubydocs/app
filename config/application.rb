require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

I18n.config.enforce_available_locales = false

Bundler.require(:default, Rails.env)

module RubyDocs
  class Application < Rails::Application
    config.assets.precompile += %w(
      show-doc-collection.css
    )

    config.secret_key_base = ENV.fetch('SECRET_KEY_BASE')

    Rails.application.routes.default_url_options =
      config.action_mailer.default_url_options = {
        host:     ENV.fetch('HOST'),
        protocol: ENV['PROTOCOL'] || 'http'
      }

    config.i18n.enforce_available_locales = false

    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end
