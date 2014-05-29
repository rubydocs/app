ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

FactoryGirl::SyntaxRunner.send :include, FactoryGirlHelpers

RSpec.configure do |config|
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    begin
      FactoryGirl.lint
    ensure
      DatabaseRewinder.clean_all
    end
  end

  config.after :each do
    DatabaseRewinder.clean
  end
end
