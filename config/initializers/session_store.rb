RubyDocs::Application.config.session_store :redis_store,
  redis_server: Settings.redis.to_hash.merge(namespace: 'sessions'),
  expires_in: 1.day
