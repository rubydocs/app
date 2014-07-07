Rails.application.config.cache_store = :redis_store, REDIS_CONFIG.merge(namespace: 'cache', expires_in: 1.year)
