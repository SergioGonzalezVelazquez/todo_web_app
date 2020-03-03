Rails.application.routes.draw do
  get 'page/login'

  match '/register',        to: 'page#register',          via: 'get'
  match '/login',           to: 'page#login',             via: 'get'
  match '/forgot-password', to: 'page#forgot-password',   via: 'get'
  match '/index',           to: 'tasks#index',   via: 'get'
  match '/today',           to: 'tasks#today',   via: 'get'
  match '/week',           to: 'tasks#week',   via: 'get'
 
  resources :tasks do
    member do
      post 'mark_as_completed'
    end
  end
  
  
  root 'page#login'
end