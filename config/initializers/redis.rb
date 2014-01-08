require 'fakeredis' if Rails.env.test?

raise 'Redis settings not found.' unless Settings.redis?

REDIS_CONNECTION_POOL = ConnectionPool.new(size: 10, timeout: 1) do
  Redis.new Settings.redis.to_hash
end

# Helper module when sending only a single command to Redis
module R
  def self.method_missing(method, *args, &block)
    REDIS_CONNECTION_POOL.with do |redis|
      redis.send(method, *args, &block)
    end
  end
end
