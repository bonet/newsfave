Silverstar::Application.routes.draw do
  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  resources :users, :only => [:show]
  
  match '/feedlist', :to => 'pages#feedlist'
  match '/about', :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  match '/feed_subscribe', :to => 'users#feed_subscribe'
  
  root :to => 'pages#home'
  
end
