Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/", to: "home#index"

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, only: [:index, :show] do
    resource :reviews, only: [:new, :create]
  end

  resources  :reviews, only: [:edit, :update, :destroy]

  resources :users, only: [:create, :update]
  get "/register", to: "users#new"
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  get "/profile/edit_password", to: "users#edit_password"

  get "/profile/orders", to: "user/orders#index"
  get "/profile/orders/new", to: "user/orders#new"
  post "/orders", to: "user/orders#create"
  get "/profile/orders/:id", to: "user/orders#show"
  patch "/profile/orders/:id", to: "user/orders#update"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  namespace :merchant, as: :merchant_dash do
    get "/", to: "dashboard#index"
    resources :items, only: [:index, :edit, :update, :destroy, :new, :create]
    resources :orders, only: [:show]
    patch "/items/:id/toggle_status", to: "items#toggle_status"
    patch "/orders/:id/item_orders/:item_order_id", to: "orders#update"
  end

  namespace :admin, as: :admin_dash do
    get "/", to: "dashboard#index"
    resources :orders, only: [:update]
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show, :edit, :update] do
      resources :orders, only: [:show]
      patch "/orders/:id", to: "orders#cancel"
    end
  end
end
