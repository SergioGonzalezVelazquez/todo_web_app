class Admin::ProjectsController < Admin::ApplicationController
  def index
    @projects = Project.all
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_back(fallback_location: root_path)
  end

  def edit
    @project = Project.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(task_params)
      flash[:notice] = "Project has been updated."
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = "Project has not been updated."
      render "edit"
    end
  end

  private

  def task_params
    params.require(:project).permit(:name, :description)
  end
end
