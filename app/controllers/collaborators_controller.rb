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

    if !@user.nil? && !@user.nil?
      # Check if user has been invited yet
      @unique = Collaborator.where(:project_id => params[:project_id]).where(:user_id => @user.id).where(:status => ["pending", "accepted"]).count

      if @unique == 0
        puts "unitque"
        @collaborator.user_id = @user.id
        @collaborator.project_id = params[:project_id]
        @collaborator.status = 'pending'
        if @collaborator.save
          puts "guardado!!!!"
          
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
        puts "user already exists"
        flash[:errors] = "User already invited"
      end
    else
      puts "user not found"
      flash[:errors] = "User not found"
    end
    redirect_back(fallback_location: root_path)
  end

  def accept
    puts "ACCEPT!!!!!!!!!!!!!!!!!"
    @collaborator = Collaborator.where(:project_id => params[:project_id]).where(:user_id => current_user.id).where(:status => "pending").first
    
    if !@collaborator.nil?
      puts "existe este colllaborator, lo he encontrado"

      @collaborator.update_attribute(:status, "accepted")
      # Mark notification as not pending

    end 
    redirect_back(fallback_location: root_path)
  end

  def destroy
    puts "destroy"
    @collaborator = Collaborator.find(params[:id])
    @user_id = @collaborator.user_id
    @project_id = @collaborator.project_id

    if @collaborator.destroy && @collaborator.status == 'pending'
      # Destroy notification
      @notification = Notification.find_by(project_id:  @project_id, user_id: @user_id)
      Notification.destroy(@notification.id)
      puts "notificatión borrada"
    end 

    redirect_back(fallback_location: root_path)
  end
end
