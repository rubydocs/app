require 'connection_pool'

if %w(development test).include?(Rails.env)
  require 'fakeredis'
end

Redis.current = ConnectionPool::Wrapper.new(size: 10) do
  Redis.new url: ENV.fetch('REDIS_URL')
end
