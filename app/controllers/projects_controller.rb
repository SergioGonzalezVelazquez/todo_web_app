class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])

    if @project.author != current_user
      flash.now[:alert] = "Forbidden You cannot see this project."
      redirect_back(fallback_location: root_path)
    end

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

    # Renders error modal
    if @project.author != current_user
      respond_to do |format|
        format.js {
          render "edit", :locals => { :error => true, :msg => "You cannot edit this project!" }
        }
      end
      # Renders form to edit task
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def create
    @project = Project.new(project_params)

    # set project’s author
    @project.author = current_user

    if @project.save
      redirect_back(fallback_location: root_path)
    else
      render "new"
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_back(fallback_location: root_path)
    else
      render "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.author != current_user
      flash.now[:alert] = "You cannot delete another user’s project!."
      redirect_back(fallback_location: root_path)
    else
      @project.destroy
      redirect_to projects_path
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
