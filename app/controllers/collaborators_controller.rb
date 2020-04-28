class CollaboratorsController < ApplicationController
  before_action { flash.clear }

  def new
    @project = Project.find params[:project_id]

    respond_to do |format|
      format.js
    end
  end

  # Create collaborator with 'pending' status is equivalent to send an invitation
  # We also check if a user is yet a project collaborator, or, if this user does not exists
  def create
    @collaborator = Collaborator.new

    @user = User.find_by(:email => params[:user_email])
    @project = Project.find params[:project_id]

    if @project.author != current_user
      flash.now[:alert] = "You cannot invite users to this project"
      redirect_back(fallback_location: root_path)
    end

    if !@user.nil? && !@user.nil?
      # Check if user has been invited yet
      @unique = Collaborator.where(:project_id => params[:project_id]).where(:user_id => @user.id).where(:status => ["pending", "accepted"]).count

      if @unique == 0
        @collaborator.user_id = @user.id
        @collaborator.project_id = params[:project_id]
        @collaborator.status = "pending"
        if @collaborator.save

          # Create notification
          @notification = Notification.new
          @notification.user_id = @user.id
          @notification.project_id = params[:project_id]
          @notification.notification_type = "invitation"
          @notification.text = @project.author.email + " has invited you to collaborate in " + @project.name
          @notification.pending = true
          @notification.save
        end
      else
        flash[:errors] = "User already invited"
      end
    else
      flash[:errors] = "User not found"
    end
    redirect_back(fallback_location: root_path)
  end

  def revoke
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])

    if project.author != current_user && user != current_user
      flash.now[:alert] = "You cannot revoke collaborators in this project."
      redirect_back(fallback_location: root_path)
    end

    collaborator = Collaborator.where(:project_id => params[:project_id]).where(:user_id => params[:user_id]).where(:status => "accepted").first
    if !collaborator.nil?
      collaborator.update_attribute(:status, "revoked")
    end

    if collaborator.user_id == current_user.id
      redirect_to(projects_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  # Cancel invitation
  def destroy
    @collaborator = Collaborator.find(params[:id])
    @user_id = @collaborator.user_id
    @project_id = @collaborator.project_id


    if @collaborator.destroy && @collaborator.status == "pending"
      # Destroy notification
      @notification = Notification.where(:project_id => @project_id).where(:user_id => @user_id).where(:notification_type => "invitation").where(:pending => true).first
      Notification.destroy(@notification.id)
    end

    redirect_back(fallback_location: root_path)
  end
end
