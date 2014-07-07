REDIS_CONFIG = if Settings.redis?
  Settings.redis.to_hash
else
  # Try to read from config/redis.yml
  YAML.load_file(Rails.root.join('config', 'redis.yml')).with_indifferent_access rescue nil
end

raise 'Redis config not found.' if REDIS_CONFIG.blank?

REDIS_URL = "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}/#{REDIS_CONFIG[:db]}"
