Silverstar::Application.routes.draw do
  
  get "sessions/new"

  resources :users
  
  resources :sessions, :only => [:new, :create, :destroy]

  match '/feedlist', :to => 'pages#feedlist'
  match '/about', :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/feed_subscribe', :to => 'users#feed_subscribe'
  
  root :to => 'pages#home'
  
end
