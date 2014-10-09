Rails.application.routes.draw do
  root "welcome#index"

  get "/login"          => "sessions#new"
  get "/oauth2callback" => "sessions#oauth_create"
  resource  :session, only: [:create, :destroy]

  resources :users do
    member do
      get   "password"
      patch "password", action: "update_password"
      get   "confirm_delete"
    end
  end
  resources :recipes, except: [:edit, :update, :destroy]
end
