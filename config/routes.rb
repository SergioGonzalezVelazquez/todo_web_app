Rails.application.routes.draw do
  #get 'page/login'

  #User routes
  #match '/register',        to: 'page#register',          via: 'get'
  #match '/login',           to: 'page#login',             via: 'get'
  #match '/forgot-password', to: 'page#forgot-password',   via: 'get'

  #Addtional tasks routes
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