Rails.application.config.cache_store = :redis_store, REDIS_CONFIG.merge(namespace: 'cache', expires_in: 1.year)

Rails.application.config.action_dispatch.rack_cache = %i(metastore entitystore).each_with_object({}) do |store, hash|
  hash[store] = "#{REDIS_URL}/rack_cache/#{store}"
end

Rails.application.config.session_store :redis_store,
  redis_server: REDIS_CONFIG.merge(namespace: 'sessions'),
  expires_in: 1.day
