require 'sidekiq/web'
require 'sidetiq/web'

RubyDocs::Application.routes.draw do
  mount Sidekiq::Web => 'sidekiq'

  get 'favicon.ico' => redirect(ActionController::Base.helpers.image_path('favicon.ico'))

  resources :email_notifications, only: :create
  resources :doc_collections, only: :create

  get ':slug(*path)' => 'doc_collections#show', as: 'doc_collection'

  root to: 'pages#show', id: 'home'

  default_url_options host: Settings.host
end
