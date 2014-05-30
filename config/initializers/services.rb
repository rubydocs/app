Services.configure do |config|
  config.redis = R
  config.host  = Settings.host
end
