Airbrake.configure do |config|
  config.api_key = Settings.airbrake_api_key
  config.host    = 'err.krautcomputing.com'
  config.port    = 80
  config.secure  = config.port == 443
  config.async do |notice|
    AirbrakeDeliveryWorker.perform_async notice.to_xml
  end
end
