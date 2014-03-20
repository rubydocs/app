source 'https://rubygems.org'
source 'https://rails-assets.org'

# Load local Gemfile
local_gemfile = File.expand_path('~/.Gemfile')
instance_eval(File.read(local_gemfile)) if File.exist?(local_gemfile)

gem 'rails',                          '4.0.3'
gem 'pg',                             '0.17.0'
gem 'haml-rails',                     '0.5.3'
gem 'sass-rails',                     '4.0.0'
gem 'jquery-rails',                   '3.0.4'
gem 'compass-rails',                  '1.1.2'
gem 'uglifier',                       '2.2.1'
gem 'coffee-rails',                   '4.0.0'
gem 'therubyracer',                   '0.12.0', platforms: :ruby
gem 'sdoc',                           github: 'krautcomputing/sdoc'
gem 'git',                            github: 'schacon/ruby-git' # TODO: Update to released gem once > 1.2.6 is released.
gem 'high_voltage',                   '2.0.0'
gem 'aws-sdk',                        '1.30.0'
gem 'nifty_settings',                 '1.0.1'
gem 'friendly_id',                    '5.0.2'
gem 'squeel',                         '1.1.1'
gem 'capistrano',                     '2.15.5'
gem 'postgres_ext',                   '2.1.3'
gem 'airbrake',                       '3.1.14'
gem 'rubyzip',                        '1.1.2'
gem 'tries',                          '0.3.2'

# Frontend
gem 'bootstrap-sass',                 '3.0.2.1'
gem 'rails_bootstrap_navbar',         '2.0.1'
gem 'font-awesome-rails',             '4.0.3.0'
gem 'rails-assets-jquery.smooth-scroll', '1.4.13'

# Redis
gem 'redis',                          '3.0.6'
gem 'redis-namespace',                '1.4.1'
gem 'redis-rails',                    '4.0.0'
gem 'connection_pool',                '1.2.0'
gem 'redis-rack-cache',               '1.2.2'

# Background jobs
gem 'sidekiq',                        '2.17.1' # Should be loaded after Airbrake
gem 'sidekiq-failures',               '0.3.0'
gem 'sidetiq',                        '0.5.0'
gem 'sinatra',                        '1.4.4', require: false # For Sidekiq Web
gem 'slim',                           '2.0.2'                 # For Sidekiq Web

# Profiling & performance tracking
gem 'newrelic_rpm',                   '3.7.1.180'
gem 'rack-mini-profiler',             '0.1.31'

group :test do
  gem 'fakeredis',                    '0.4.3'
end

group :development do
  gem 'letter_opener',                '1.2.0'
  gem 'sprinkle',                     '0.7.5', require: false
end

group :production do
  gem 'puma',                         '2.7.1', require: false
end
