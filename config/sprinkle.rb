policy :app_server, roles: :app do
  requires :nginx_config
  requires :monit_config
  requires :app_logrotate
end

deployment do
  delivery :capistrano do
    recipes 'Capfile'

    set :user, 'root'
    set :password, ENV['ROOT_PWD'] if ENV['ROOT_PWD'].present?
    set :use_sudo, true

    # Make Capistrano variables available to Sprinkle packages
    # see https://github.com/crafterm/sprinkle/issues/57
    class Sprinkle::Package::Package
      @capistrano = {}

      class << self
        def variables=(variables)
          @capistrano = variables
        end

        def fetch(name)
          @capistrano[name] or raise StandardError, "Capistrano variable #{name} not found."
        end
      end
    end
    Sprinkle::Package::Package.variables = self.variables
  end

  source do
    prefix   '/usr/local'
    archives '/usr/local/sources'
    builds   '/usr/local/build'
  end
end

Dir[File.expand_path('../sprinkle/packages/*.rb', __FILE__)].each do |file|
  require file
end
