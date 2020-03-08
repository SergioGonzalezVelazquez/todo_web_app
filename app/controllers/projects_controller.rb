class ProjectsController < ApplicationController
    

  def show
    @projects = Project.all
    @project = Project.find(params[:id])

    @pending_tasks = []
    @completed_tasks = []
    @project.tasks.each do |task|
      @pending_tasks << task if task.completed == false
      @completed_tasks << task if task.completed == true
    end 

  end
  
  def new
    @project = Project.new 

    respond_to do |format|
      format.js
    end 
  end

  def edit
    @project = Project.find(params[:id])
    respond_to do |format|
      format.js
    end 
  end

  def create
    @project = Project.new(project_params)
         
    if @project.save
      redirect_back(fallback_location: root_path)
    else 
      render 'new'
    end
  end

  def update
    @project = Project.find(params[:id])
   
    if @project.update(project_params)
      redirect_back(fallback_location: root_path)
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
           
    redirect_to projects_path
  end

  private
  def project_params
      params.require(:project).permit(:name, :description)
  end

        
end
