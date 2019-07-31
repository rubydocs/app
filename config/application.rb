require File.expand_path('../boot', __FILE__)

# Silence warnings while loading Rails gems, since we're using Ruby 2.6 and Rails 4,
# we would otherwise get "warning: BigDecimal.new is deprecated; use BigDecimal() method instead."
old_verbose, $VERBOSE = $VERBOSE, nil
begin
  require 'active_record/railtie'
  require 'action_controller/railtie'
  require 'action_mailer/railtie'
  require 'sprockets/railtie'
ensure
  $VERBOSE = old_verbose
end

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
  end
end
