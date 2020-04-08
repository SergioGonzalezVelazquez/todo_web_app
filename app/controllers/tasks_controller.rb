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

  def edit
    @task = Task.find(params[:id])

    respond_to do |format|
      # Renders error modal
      if @task.author != current_user
        format.js {
          render "edit", :locals => { :error => true, :msg => "You cannot edit another user's task!" }
        }

        # Renders form to edit task
      else
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
    if @task.author != current_user
      flash.now[:alert] = "You cannot delete another user’s task!."
      redirect_back(fallback_location: root_path)
    else
      @task.destroy
      redirect_back(fallback_location: root_path)
    end
  end

  def mark_as_completed
    @task = Task.find(params[:id])
    if @task.author != current_user
      flash.now[:alert] = "You cannot mark as complete another user’s task!."
      redirect_back(fallback_location: root_path)
    else
      @task.update_attributes(:completed => true)
      @task.save
      redirect_back(fallback_location: root_path)
    end
  end

  def add_to_project
    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(task_params)
    redirect_back(fallback_location: root_path)
  end

  def remove_from_project
    @task = Task.find(params[:id])

    @task.update_attributes(:project_id => nil)
    @task.save
    redirect_back(fallback_location: root_path)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :priority, :deadline)
  end
end
