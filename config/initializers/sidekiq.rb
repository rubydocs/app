require 'sidekiq/testing/inline' if %w(development test).include?(Rails.env)

if Settings.sidekiq?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Settings.sidekiq.username && password == Settings.sidekiq.password
  end
end

Sidekiq.configure_server do |config|
  config.redis         = { url: REDIS_URL, namespace: 'sidekiq' }
  config.poll_interval = 1
  config.error_handlers << -> (exception, context) { Airbrake.notify_or_ignore(exception, parameters: context) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: REDIS_URL, namespace: 'sidekiq', size: 1 }
end

Sidekiq.default_worker_options = {
  'retry'     => false,
  'backtrace' => true
}
