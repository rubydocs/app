require 'fakeredis' if %w(development test).include?(Rails.env)

REDIS_CONNECTION_POOL = ConnectionPool.new(size: 10, timeout: 1) do
  Redis.new REDIS_CONFIG
end

# Helper module when sending only a single command to Redis
module R
  def self.method_missing(method, *args, &block)
    REDIS_CONNECTION_POOL.with do |redis|
      redis.send(method, *args, &block)
    end
  end
end
