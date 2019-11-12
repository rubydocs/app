source 'https://rubygems.org'

ruby '2.5.5'

# Return early if this file is parsed by the Bundler plugin DSL.
# This won't let us access dependencies in common-gems.
return if self.is_a?(Bundler::Plugin::DSL)

gem 'rails', '~> 4.2.7'

# Load common gems
%w(
  rails
  redis
  testing-basics
  testing-rspec
).each do |m|
  eval_gemfile File.join('common-gems', m, 'Gemfile')
end

gem 'aws-sdk-s3',             '~> 1.30'
gem 'bootstrap-sass',         '~> 3.0'
gem 'dotenv-heroku',          '~> 0.0'
gem 'dotenv-rails',           '~> 2.7'
gem 'envkey',                 '~> 1.0', '!= 1.2.6' # v1.2.6 breaks loading env vars in test env
gem 'font-awesome-rails',     '~> 4.0'
gem 'friendly_id',            '~> 5.0'
gem 'git',                    '~> 1.2'
gem 'high_voltage',           '~> 2.0'
gem 'net-sftp',               '~> 2.1'
gem 'rails_bootstrap_navbar', '~> 2.0'
gem 'render_anywhere',        '~> 0.0', require: false
gem 'rest-client',            '~> 2.0'
gem 'rubyzip',                '~> 1.1'
gem 'sdoc',                   '~> 1.0'
gem 'sitemap_generator',      '~> 6.0'
gem 'rack-cors',              '~> 1.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery.smooth-scroll',      '~> 1.4'
  gem 'rails-assets-jquery-cookie',             '~> 1.4'
  gem 'rails-assets-select2',                   '~> 4.0'
  gem 'rails-assets-select2-bootstrap-theme',   '0.1.0.beta.7' # TODO: Update to v0.1 when released
end
