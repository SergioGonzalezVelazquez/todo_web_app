Rails.application.routes.draw do
  get 'page/login'

  match '/register',        to: 'page#register',          via: 'get'
  match '/login',           to: 'page#login',             via: 'get'
  match '/forgot-password', to: 'page#forgot-password',   via: 'get'
  match '/index',           to: 'tasks#index',   via: 'get'
 
  resources :tasks
  
  root 'page#login'
end