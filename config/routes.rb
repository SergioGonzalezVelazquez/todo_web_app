Rails.application.routes.draw do
  
  namespace :admin do
    root "application#index"

    resources :tasks
    resources :projects
    resources :users
  end

  devise_for :users, :controllers => { registrations: 'registrations' }

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