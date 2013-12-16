require 'fakeredis' if Rails.env.test?

raise 'Redis settings not found.' unless Settings.redis?

REDIS_CONNECTION_POOL = ConnectionPool.new(size: 10, timeout: 1) do
  Redis.new Settings.redis.to_hash
end

# For use in console
R = ConnectionPool::Wrapper.new(size: 1, timeout: 1) do
  Redis.new Settings.redis.to_hash
end
