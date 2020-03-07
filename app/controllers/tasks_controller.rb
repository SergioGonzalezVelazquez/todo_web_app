class TasksController < ApplicationController
    
  def index
    @pending_tasks = Task.where(:completed => false)
    @completed_tasks_count = Task.where(:completed => true).count
    @today_tasks_percent = Task.where(:deadline => Date.today).where(:completed => false).count
    @week_tasks_count = Task.where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
    @projects = Project.all
  end

  def today  
    @today_tasks = Task.where(:deadline => Date.today).where(:completed => false)
    @today_tasks_completed = Task.where(:deadline => Date.today).where(:completed => true).count
    @projects = Project.all
  end 

  def week    
    @week_tasks_pending = Task.where(:deadline => Date.today..Date.today + 6).where(:completed => false).count
    @week_tasks_completed = Task.where(:deadline => Date.today..Date.today + 6).where(:completed => true).count
    @week_tasks = []

    @week_tasks << Task.where(:deadline => Date.today).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 1).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 2).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 3).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 4).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 5).where(:completed => false)
    @week_tasks << Task.where(:deadline => Date.today + 6).where(:completed => false)
    
    @projects = Project.all
  end 
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new 

    respond_to do |format|
      format.js
    end 
  end

  def edit
    @task = Task.find(params[:id])
    respond_to do |format|
      format.js
    end 
  end

  def update
    @task = Task.find(params[:id])
   
    if @task.update(task_params)
      redirect_back(fallback_location: root_path)
    else
      render 'edit'
    end
  end

  def mark_as_completed
    @task = Task.find(params[:id])

    @task.update_attributes(:completed => true)
    @task.save
    redirect_back(fallback_location: root_path)
  end
   

  def create
    @task = Task.new(task_params)
         
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

  private
  def task_params
      params.require(:task).permit(:name, :description, :priority, :deadline)
  end

        
end
