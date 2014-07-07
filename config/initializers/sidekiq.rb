require 'sidekiq/testing/inline' if %w(development test).include?(Rails.env)

redis_url = "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}/#{REDIS_CONFIG[:db]}"

if Settings.sidekiq?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == Settings.sidekiq.username && password == Settings.sidekiq.password
  end
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
