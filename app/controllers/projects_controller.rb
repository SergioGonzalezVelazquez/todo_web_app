class ProjectsController < ApplicationController
  def index
    @projects_owner = Project.where(:author_id => current_user)
    #puts current_user.projects_shared.count
    @projects_shared = Project.joins(:collaborators).where(:collaborators => { :user_id => current_user.id, :status => "accepted" })
  end

  def show
    @project = Project.find(params[:id])

    # Check if user is project collaborator
    isCollaborator = Collaborator.where(:project_id => @project.id).where(:status => "accepted").where(:user_id => current_user.id).count > 0

    if @project.author != current_user
      if !isCollaborator
        flash.now[:alert] = "Forbidden You cannot see this project."
        redirect_back(fallback_location: root_path)
      end
    end

    @pending_tasks = []
    @completed_tasks = []
    @project.tasks.each do |task|
      @pending_tasks << task if task.completed == false
      @completed_tasks << task if task.completed == true
    end

    @collaborators = Collaborator.where(:project_id => @project.id).where(:status => "accepted").count

    # pending invitations
    @pending_invitations = Collaborator.where(:project_id => @project.id).where(:status => "pending").count
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

  def management
    @project = Project.find(params[:project_id])

    # Check if user is project collaborator
    isCollaborator = Collaborator.where(:project_id => @project.id).where(:status => "accepted").where(:user_id => current_user.id).count > 0

    if @project.author != current_user && !isCollaborator
        flash.now[:alert] = "Forbidden You cannot see this project."
        redirect_back(fallback_location: root_path)
    end 

    # pending invitations
    @collaborators = Collaborator.where(:project_id => @project.id).where(:status => "accepted")

    # pending invitations
    @pending_invitations = Collaborator.where(:project_id => @project.id).where(:status => "pending")


    if isCollaborator
      render "projects/management_collaborator"
    else
      # pending invitations
      @pending_invitations = Collaborator.where(:project_id => @project.id).where(:status => "pending")
      render "projects/management_author"
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
