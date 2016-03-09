require 'connection_pool'

Redis.current = ConnectionPool::Wrapper.new(size: 10) do
  Redis.new REDIS_CONFIG
end
