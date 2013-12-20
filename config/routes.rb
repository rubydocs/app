require 'sidekiq/web'

RubyDocs::Application.routes.draw do
  resources :doc_collections, only: :create
  get ':doc_collection_slug' => 'doc_collections#show', as: 'doc_collection'

  root to: 'pages#show', id: 'home'
end
