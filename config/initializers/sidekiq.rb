require 'sidekiq/testing/inline' if %w(development test).include?(Rails.env)

raise 'Redis settings not found.' unless Settings.redis?

redis_url = "redis://#{Settings.redis[:host]}:#{Settings.redis[:port]}/#{Settings.redis[:db]}"

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == Settings.sidekiq.username && password == Settings.sidekiq.password
end

Sidekiq.configure_server do |config|
  config.redis         = { url: redis_url, namespace: 'sidekiq' }
  config.poll_interval = 1
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: 'sidekiq', size: 1 }
end

Sidekiq.default_worker_options = {
  'retry'     => false,
  'backtrace' => true
}
