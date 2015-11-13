Rails.application.routes.draw do
  resources :sites, :only => [:create]
  resources :users, :only => [:create]

  get 'site', :to => 'sites#show', :constraints => { :url => /.+/ }

  root :to => 'home#index'

  match '*anything' => 'application#options', :via => [:options]
end
