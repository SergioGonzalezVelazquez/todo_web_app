Rails.application.routes.draw do
  get 'page/index'
  get 'page/login'

  match '/register',        to: 'page#register',          via: 'get'
  match '/login',           to: 'page#login',             via: 'get'
  match '/forgot-password', to: 'page#forgot-password',   via: 'get'
  match '/index',           to: 'page#index',   via: 'get'
 
  root 'page#login'
end