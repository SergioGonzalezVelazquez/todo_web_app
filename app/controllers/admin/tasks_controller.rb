class Admin::TasksController < Admin::ApplicationController
  def index
    @tasks = Task.all
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
           
    redirect_back(fallback_location: root_path)
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
      flash[:notice] = "Task has been updated."
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = "Task has not been updated."
      render 'edit'
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :priority, :deadline)
  end

end
