Rails.application.routes.draw do
  devise_for :users
  resources :cards
  
  resources :lists do
    member do
      patch :move
    end
  end

  root to: 'lists#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
