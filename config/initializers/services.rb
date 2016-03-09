Services.configure do |config|
  config.logger = Services::Logger::File.new(Rails.root.join('log'))
end
