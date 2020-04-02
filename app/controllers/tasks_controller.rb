class TasksController < ApplicationController
    
  def index
    @pending_tasks = Task.where(:user_id => session[:user_id]).where(:completed => false)
    @completed_tasks_count = Task.where(:user_id => session[:user_id]).where(:completed => true).count
    @today_tasks_percent = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today).where(:completed => false).count
    @week_tasks_count = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
    @projects = Project.where(:user_id => session[:user_id])
  end

  def today  
    @today_tasks = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today).where(:completed => false)
    @today_tasks_completed = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today).where(:completed => true).count
    @projects = Project.where(:user_id => session[:user_id])
  end 

  def week    
    @week_tasks_pending = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
    @week_tasks_completed = Task.where(:user_id => session[:user_id]).where(:deadline => Date.today..Date.today + 6).where(:completed => true).count
    @week_tasks = []

    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 1).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 2).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 3).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 4).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 5).where(:completed => false)
    @week_tasks << Task.where(:user_id => session[:user_id]).where(:deadline => Date.today + 6).where(:completed => false)
    
    @projects = Project.where(:user_id => session[:user_id])
  end 
  
  def new
    if !session[:user_id]
      redirect_to login_path, :alert => "You have to log in to create a new task"
    else
      @task = Task.new

      if params[:project_id].present?
        @task.project_id = params[:project_id]
      end
  
      respond_to do |format|
        format.js
      end  
    end 
  end

  def edit
    @task = Task.find(params[:id])
    flash.now[:alert] = 'Error while sending message!'
      respond_to do |format|
        format.js
      end   
  end

  def update
    @task = Task.find(params[:id])
    if @task.user_id != session[:user_id]
      render 'edit', :alert => "You cannot edit another user’s task!" 
    else
      if @task.update(task_params)
        redirect_back(fallback_location: root_path)
      else
        render 'edit'
      end
    end
  end
  
  def create
    @task = Task.new(task_params)
    @task.user_id = session[:user_id]

    if @task.save
      redirect_back(fallback_location: root_path)
    else 
      render 'new'
    end
  end


  def destroy
    @task = Task.find(params[:id])
    @task.destroy
           
    redirect_back(fallback_location: root_path)
  end

  def mark_as_completed
    @task = Task.find(params[:id])

    @task.update_attributes(:completed => true)
    @task.save
    redirect_back(fallback_location: root_path)
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
