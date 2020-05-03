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
    elsif @user == current_user
      flash.now[:alert] = "You cannot invite yourself"
    elsif !@user.nil?
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
    puts "COLLABORATOR REVOKE!!!!!"
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])

    if project.author != current_user && user != current_user
      flash.now[:alert] = "You cannot revoke collaborators in this project."
      redirect_back(fallback_location: root_path)
    end

    collaborator = Collaborator.where(:project_id => params[:project_id]).where(:user_id => params[:user_id]).where(:status => "accepted").first
    if !collaborator.nil?
      puts "COLLABORATOR UPDATE ATRIBUTE"
      collaborator.update_attribute(:status, "revoked")
      # Then, we notify that an user has left the project
      user_ids = User.joins(:collaborators).where(:collaborators => { :project_id => collaborator.project.id, :status => "accepted" }).where.not(:collaborators => { :user_id => collaborator.user_id }).ids
      user_ids.push(collaborator.project.author.id)
      puts user_ids
      notification_text = collaborator.user.email + " has left " + collaborator.project.name
      create_notifications(user_ids, "user_abandon", notification_text, collaborator.project.id) 
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

  private
  def create_notifications(user_ids, type, text, project_id)
    user_ids.each do |id|

      # Create notification
      @notification = Notification.new
      @notification.user_id = id
      @notification.project_id = project_id
      @notification.notification_type = type
      @notification.text = text
      @notification.pending = true
      @notification.save
    end
  end
end
