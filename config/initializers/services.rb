Services.configure do |config|
  config.logger = Services::Logger::File.new(Rails.root.join('log'))
  config.redis  = R
  config.host   = Settings.host
end
