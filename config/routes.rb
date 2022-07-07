Rails.application.routes.draw do
  
  resources :orders
  resources :line_items
  resources :carts
  root 'categories#index'
  resources :categories do
    resources :services
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
