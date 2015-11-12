Rails.application.routes.draw do
  resources :sites, :only => [:create, :update]

  root :to => 'home#index'
end
