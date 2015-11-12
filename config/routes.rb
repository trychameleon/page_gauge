Rails.application.routes.draw do
  resources :sites, :only => [:create]
  resources :users, :only => [:create]

  root :to => 'home#index'
end
