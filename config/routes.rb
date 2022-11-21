# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

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

  get ":sitemap", sitemap: /sitemap[A-Za-z\d.]*/, to: redirect { "https://#{ENV.fetch "CLOUDFLARE_R2_BUCKET_URL"}#{_2.path}" }

  root "application#home"
end
