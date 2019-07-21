Rails.application.routes.draw do
  get 'favicon.ico'    => redirect(ActionController::Base.helpers.image_path('favicon.ico'))
  get 'sitemap(*rest)' => redirect { |_, req| "https://s3.amazonaws.com/rubydocs#{req.path}" }

  resources :email_notifications, only: :create
  resources :doc_collections, only: :create

  get ':slug(.:format)(*path)' => 'doc_collections#show', as: 'doc_collection'

  root to: 'pages#show', id: 'home'
end
