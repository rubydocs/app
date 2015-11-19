require 'readthis'

if Rails.cache.is_a?(Readthis::Cache) && REDIS_CONFIG.has_key?(:password)
  Rails.cache.pool.with do |redis|
    redis.auth REDIS_CONFIG[:password]
  end
end
