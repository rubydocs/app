RubyDocs::Application.config.session_store :redis_store,
  redis_server: REDIS_CONFIG.merge(namespace: 'sessions'),
  expires_in: 1.day
