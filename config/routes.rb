Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "home#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resource :reviews, only: [:new, :create]
  end

  resources  :reviews, only: [:edit, :update, :destroy]

  resources :orders, only: [:new, :create, :show]

  resources :users, only: [:create]
  get "/register", to: "users#new"
  get "/profile", to: "users#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  namespace :merchant, as: :merchant_dash do
    get "/", to: "dashboard#index"
  end

  namespace :admin, as: :admin_dash do
    get "/", to: "dashboard#index"
  end
end
