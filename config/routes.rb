Rails.application.routes.draw do
  get 'page/index'
  get 'user/login'

  match '/register',        to: 'user#register',          via: 'get'
  match '/login',           to: 'user#login',             via: 'get'
  match '/forgot-password', to: 'user#forgot-password',   via: 'get'
  match '/index',           to: 'page#index',   via: 'get'
 
  root 'user#login'
end