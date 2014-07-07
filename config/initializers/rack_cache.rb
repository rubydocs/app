Rails.application.config.action_dispatch.rack_cache = %i(metastore entitystore).each_with_object({}) do |store, hash|
  hash[store] = "#{REDIS_URL}/rack_cache/#{store}"
end
