Rails.application.routes.draw do
  # Administrator namespace
  namespace :admin do
    root "application#index"

    resources :tasks
    resources :projects
    resources :users
  end

  # User Management module
  devise_for :users, :controllers => { registrations: "registrations" }

  # Tasks
  resources :tasks do
    member do
      post "mark_as_completed"
    end
    member do
      post "remove_from_project"
    end
  end

  #Addtional tasks routes
  match "/index", to: "tasks#index", via: "get"
  match "/tasks/:id(.:format)", to: "tasks#index", via: "get"
  match "/today", to: "tasks#today", via: "get"
  match "/week", to: "tasks#week", via: "get"

  # Projects
  resources :projects
  match "/projects/:project_id/management", as: "project_management", to: "projects#management", via: "get"
  
  resources :collaborators, only: [:new, :create, :destroy]
  match "/collaborators/accept(.:format)", as: "accept_collaborator", to: "collaborators#accept", via: "post"
  match "/collaborators/revoke(.:format)", as: "revoke_collaborator", to: "collaborators#revoke", via: "post"


  # Relationship between tasks and projects
  match "/projects/:project_id/tasks(.:format)", as: "add_task_to_project", to: "tasks#add_task_to_project", via: "get"
  match "/projects/:project_id/tasks(.:format)", as: "project_tasks", to: "tasks#create_to_project", via: "post"

  # Notifications
  resources :notifications, only: [:index]

  root "tasks#index"
end
