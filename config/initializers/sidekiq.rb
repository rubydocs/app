require 'sidekiq/testing/inline' if %w(development test).include?(Rails.env)

if Settings.sidekiq?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Settings.sidekiq.username && password == Settings.sidekiq.password
  end
end

redis_options = { url: REDIS_URL, namespace: 'sidekiq' }

# Set Redis driver explicitly if FakeRedis is used
redis_options.merge!(driver: Redis::Connection::Memory) if defined?(Redis::Connection::Memory)

Sidekiq.configure_server do |config|
  config.redis         = redis_options
  config.error_handlers << ->(exception, context) { Airbrake.notify_or_ignore(exception, parameters: context) }
end

Sidekiq.configure_client do |config|
  config.redis = redis_options.merge(size: 1)
end

Sidekiq.default_worker_options = {
  'retry'     => false,
  'backtrace' => true
}
