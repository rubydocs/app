ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

FactoryBot::SyntaxRunner.send :include, FactoryBotHelpers

RSpec.configure do |config|
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods

  config.before :suite do
    begin
      FactoryBot.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end

  config.after :each do
    DatabaseRewinder.clean
  end
end
