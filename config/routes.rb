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
  match "/projects", to: "tasks#index", via: "get"

  # Projects
  resources :projects

  # Relationship between tasks and projects
  match "/projects/:project_id/tasks(.:format)", as: "add_task_to_project", to: "tasks#add_task_to_project", via: "get"
  match "/projects/:project_id/tasks(.:format)", as: "project_tasks", to: "tasks#create_to_project", via: "post"

  root "tasks#index"
end
