source 'https://rubygems.org'
source 'https://rails-assets.org'

ruby '2.1.2'

gem 'rails', '4.0.8'

# Load common gems
%w(
  common-gems/Gemfile
  common-gems/redis/Gemfile
  common-gems/sidekiq/Gemfile
).each do |gemfile|
  instance_eval(File.read(gemfile))
end

gem 'sdoc',                               github: 'krautcomputing/sdoc'
gem 'git',                                '1.2.7'
gem 'high_voltage',                       '2.0.0'
gem 'aws-sdk',                            '1.42.0'
gem 'friendly_id',                        '5.0.2'
gem 'squeel',                             github: 'activerecord-hackery/squeel' # TODO: Use > 1.1.1 when released
gem 'postgres_ext',                       '2.1.3'
gem 'rubyzip',                            '1.1.2'
gem 'net-sftp',                           '2.1.2'

# Frontend
gem 'bootstrap-sass',                     '3.0.2.1'
gem 'rails_bootstrap_navbar',             '2.0.1'
gem 'font-awesome-rails',                 '4.0.3.0'
gem 'rails-assets-jquery.smooth-scroll',  '1.4.13'

group :test do
  gem 'rspec-rails',                      '3.0.1'
  gem 'guard-rspec',                      '4.2.9'
  gem 'factory_girl_rails',               '4.4.1'
  gem 'database_rewinder',                '0.2.0'
end
