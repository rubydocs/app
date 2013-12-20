source 'https://rubygems.org'

# Load local Gemfile
local_gemfile = File.expand_path('~/.Gemfile')
instance_eval(File.read(local_gemfile)) if File.exist?(local_gemfile)

gem 'rails',                          '4.0.2'
gem 'pg',                             '0.17.0'
gem 'haml-rails',                     '0.4'
gem 'sass-rails',                     '4.0.0'
gem 'uglifier',                       '2.2.1'
gem 'coffee-rails',                   '4.0.0'
gem 'therubyracer',                   '0.12.0', platforms: :ruby
gem 'sdoc',                           github: 'vikassy/sdoc', branch: 'rdoc-4'
gem 'git',                            '1.2.6'
gem 'high_voltage',                   '2.0.0'
gem 'aws-sdk',                        '1.30.0'
gem 'nifty_settings',                 '1.0.1'
gem 'friendly_id',                    '5.0.2'
gem 'squeel',                         '1.1.1'
gem 'capistrano',                     '2.15.5'

# Frontend
gem 'bootstrap-sass',                 '3.0.2.1'
gem 'rails_bootstrap_navbar',         '1.0.1'

# Redis
gem 'redis',                          '3.0.6'
gem 'redis-namespace',                '1.4.1'
gem 'redis-rails',                    '4.0.0'
gem 'connection_pool',                '1.2.0'
gem 'redis-rack-cache',               '1.2.2'

# Background jobs
gem 'sidekiq',                        github: 'krautcomputing/sidekiq', branch: 'log_job_args' # Should be loaded after Airbrake
gem 'sidekiq-unique-jobs',            '2.7.0'
gem 'sidekiq-failures',               '0.2.2'
gem 'sinatra',                        '1.4.4', require: false # For Sidekiq Web
gem 'slim',                           '2.0.2'                 # For Sidekiq Web

group :test do
  gem 'fakeredis',                    '0.4.3'
end

group :development do
  gem 'sprinkle',                     '0.7.5', require: false
end

group :production do
  gem 'puma',                         '2.7.1', require: false
end
