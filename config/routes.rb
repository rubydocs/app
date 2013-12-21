require 'sidekiq/web'

RubyDocs::Application.routes.draw do
  mount Sidekiq::Web => 'sidekiq'

  get 'favicon.ico' => redirect(ActionController::Base.helpers.image_path('favicon.ico'))

  resources :doc_collections, only: :create
  get ':doc_collection_slug' => 'doc_collections#show', as: 'doc_collection'

  root to: 'pages#show', id: 'home'
end
