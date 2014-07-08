source 'https://rubygems.org'
source 'https://rails-assets.org'

# Load common Gemfile
['common-gems/Gemfile', 'common-gems/rails4/Gemfile'].each do |gemfile|
  instance_eval(File.read(gemfile))
end

ruby '2.1.2'

gem 'rails',                              '4.0.6'
gem 'pg',                                 '0.17.0'
gem 'haml-rails',                         '0.5.3'
gem 'sass-rails',                         '4.0.2'
gem 'jquery-rails',                       '3.0.4'
gem 'compass-rails',                      '1.1.2'
gem 'uglifier',                           '2.2.1'
gem 'coffee-rails',                       '4.0.0'
gem 'sdoc',                               github: 'krautcomputing/sdoc'
gem 'git',                                '1.2.7'
gem 'high_voltage',                       '2.0.0'
gem 'aws-sdk',                            '1.42.0'
gem 'friendly_id',                        '5.0.2'
gem 'squeel',                             '1.1.1'
gem 'postgres_ext',                       '2.1.3'
gem 'rubyzip',                            '1.1.2'
gem 'tries',                              '0.3.2'
gem 'services',                           '0.1.2'
gem 'net-sftp',                           '2.1.2'

# Frontend
gem 'bootstrap-sass',                     '3.0.2.1'
gem 'rails_bootstrap_navbar',             '2.0.1'
gem 'font-awesome-rails',                 '4.0.3.0'
gem 'rails-assets-jquery.smooth-scroll',  '1.4.13'

# Background jobs
gem 'sidekiq',                            '2.17.1' # Should be loaded after Airbrake
gem 'sidekiq-failures',                   '0.3.0'
gem 'sidetiq',                            '0.6.1'
gem 'sinatra',                            '1.4.4', require: false # For Sidekiq Web
gem 'slim',                               '2.0.2'                 # For Sidekiq Web

# Profiling & performance tracking
gem 'newrelic_rpm',                       '3.7.1.180'
gem 'rack-mini-profiler',                 '0.1.31'

group :test do
  gem 'rspec-rails',                      '3.0.1'
  gem 'guard-rspec',                      '4.2.9'
  gem 'factory_girl_rails',               '4.4.1'
  gem 'database_rewinder',                '0.2.0'
end

group :development do
  gem 'letter_opener',                    '1.2.0'
  gem 'sprinkle',                         '0.7.5', require: false
end
