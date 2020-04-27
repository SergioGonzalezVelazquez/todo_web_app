class TasksController < ApplicationController
  def index
    @pending_tasks = Task.where(:author_id => current_user).where(:completed => false)
    @completed_tasks_count = Task.where(:author_id => current_user).where(:completed => true).count
    @today_tasks_count = Task.where(:author_id => current_user).where(:deadline => Date.today).where(:completed => false).count
    @week_tasks_count = Task.where(:author_id => current_user).where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
  end

  def today
    @today_tasks = Task.where(:author_id => current_user).where(:deadline => Date.today).where(:completed => false)
    @today_tasks_completed = Task.where(:author_id => current_user).where(:deadline => Date.today).where(:completed => true).count
  end

  def week
    @week_tasks_pending = Task.where(:author_id => current_user).where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
    @week_tasks_completed = Task.where(:author_id => current_user).where(:deadline => Date.today..Date.today + 6).where(:completed => true).count
    @week_tasks = []

    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 1).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 2).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 3).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 4).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 5).where(:completed => false)
    @week_tasks << Task.where(:author_id => current_user).where(:deadline => Date.today + 6).where(:completed => false)
  end

  def new
    @task = Task.new

    if params[:project_id].present?
      @task.project_id = params[:project_id]
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
    @task = Task.find(params[:id])

    # Renders error modal
    if @task.author != current_user
      respond_to do |format|
        format.js {
          render "edit", :locals => { :error => true, :msg => "You cannot edit another user's task!" }
        }
      end

      # Renders form to edit task
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_back(fallback_location: root_path)
    else
      render "edit"
    end
  end

  def create
    @task = Task.new(task_params)

    # set the task’s author
    @task.author = current_user

    if @task.save
      redirect_back(fallback_location: root_path)
    else
      render "new"
    end
  end

  def destroy
    @task = Task.find(params[:id])

    # If task does not belong to any project, only its author can destroy it
    if @task.project_id.nil?
      if @task.author != current_user
        flash.now[:alert] = "You cannot delete another user’s task!."
        redirect_back(fallback_location: root_path)
      else
        @task.destroy
        redirect_back(fallback_location: root_path)
      end

      # If task belongs to any project, both  author and collaborators can destroy it
    else
      project = Project.find(@task.project_id)
      isCollaborator = Collaborator.where(:project_id => @task.project_id).where(:status => "accepted").where(:user_id => current_user.id).count > 0

      if !isCollaborator && project.author != current_user
        flash.now[:alert] = "You cannot delete another user’s task!."
        redirect_back(fallback_location: root_path)
      else
        @task.destroy
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def mark_as_completed
    @task = Task.find(params[:id])

    # If task does not belong to any project, only its author can mark it as complete
    if @task.project_id.nil?
      if @task.author != current_user
        flash.now[:alert] = "You cannot mark as complete another user’s task!."
        redirect_back(fallback_location: root_path)
      else
        @task.update_attributes(:completed => true)
        @task.save
        redirect_back(fallback_location: root_path)
      end

      # If task belongs to any project, both  author and collaborators can mark it as complete
    else
      project = Project.find(@task.project_id)
      isCollaborator = Collaborator.where(:project_id => @task.project_id).where(:status => "accepted").where(:user_id => current_user.id).count > 0

      if !isCollaborator && project.author != current_user
        flash.now[:alert] = "You cannot mark as complete tasks in this project!."
        redirect_back(fallback_location: root_path)
      else
        @task.update_attributes(:completed => true)
        @task.save
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def add_task_to_project
    puts "add task to project renders"
    @project = Project.find(params[:project_id])
    respond_to do |format|
      format.js {
        render "add_task_to_project"
      }
    end
  end

  def create_to_project
    @task = Task.new(task_params)

    # set the task’s project
    @task.project_id = params[:project_id]

    # set the task’s author
    @task.author = current_user

    @task.save
    redirect_back(fallback_location: root_path)
  end

  def remove_from_project
    @task = Task.find(params[:id])

    @task.update_attributes(:project_id => nil)
    if @task.save
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :priority, :deadline)
  end
end
