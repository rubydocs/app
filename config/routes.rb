require "sidekiq/web"

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    {
      username => "SIDEKIQ_USERNAME",
      password => "SIDEKIQ_PASSWORD"
    }.map { ActiveSupport::SecurityUtils.secure_compare _1, ENV.fetch(_2) }
     .all?
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => "sidekiq"

  root "application#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
