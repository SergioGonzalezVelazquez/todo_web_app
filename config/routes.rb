Rails.application.routes.draw do
  resources :users, only: [:new, :create, :destroy, :edit, :update]
  
  # Session management
  get 'login', to: 'sessions#new'   
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy' 

  # Addtional tasks routes
  match '/index',           to: 'tasks#index',            via: 'get'
  match '/today',           to: 'tasks#today',            via: 'get'
  match '/week',            to: 'tasks#week',             via: 'get'
  match '/projects',        to: 'tasks#index',            via: 'get'
 
  resources :tasks do
    member do
      post 'mark_as_completed'
    end
    member do
      post 'remove_from_project'
    end
  end

  resources :projects 

  # Relationship between tasks and projects
  match '/projects/:project_id/tasks(.:format)', as: 'project_tasks',   to: 'tasks#add_to_project',            via: 'post'

  root 'tasks#index'
  
end