# Use cookie store in development and test, otherwise FakeRedis doesn't work.
session_store_options = if %w(development test).include?(Rails.env)
  [:cookie_store, key: '_uplink_session']
else
  [:cache_store]
end
Rails.application.config.session_store *session_store_options
