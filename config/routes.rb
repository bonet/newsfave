Silverstar::Application.routes.draw do
  
  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  resources :users, :only => [:show]
  
  match '/feedlist', :to => 'pages#feedlist'
  match '/about', :to => 'pages#about'
  match '/contact', :to => 'pages#contact'
  
  devise_scope :user do
    match '/feed_subscribe', :to => 'registrations#feed_subscribe'
  end 
  
  root :to => 'pages#home'
  
end
