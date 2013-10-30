RubyDocs::Application.routes.draw do
  resources :doc_collections, only: :create

  root to: 'pages#show', id: 'home'
end
