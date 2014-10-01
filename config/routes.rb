Rails.application.routes.draw do
  root "welcome#index"
  
  get "/login" => "sessions#new"
  resource  :session, only: [:create, :destroy]

  resources :users
  resources :recipes, except: [:edit, :update, :destroy]
end
