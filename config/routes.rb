Rails.application.routes.draw do
  root "application#home"

  get "up" => "rails/health#show", as: :rails_health_check
end
