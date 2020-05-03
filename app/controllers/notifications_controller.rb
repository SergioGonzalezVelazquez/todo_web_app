class NotificationsController < ApplicationController
  def index
    @all_notifications = Notification.where(:user_id => current_user.id).order(created_at: :desc)
  end

  def read
    @notification = Notification.find(params[:id])

    if @notification.user_id == current_user.id && @notification.pending
      @notification.update_attributes(:pending => false)
      @notification.save
    end
    redirect_back(fallback_location: root_path)
  end

  def accept
    @notification = Notification.find(params[:id])

    if @notification.user_id == current_user.id && @notification.pending && @notification.notification_type == "invitation"
      collaborator = Collaborator.where(:project_id => @notification.project_id).where(:user_id => current_user.id).where(:status => "pending").first

      if !collaborator.nil?
        collaborator.update_attribute(:status, "accepted")
        @notification.update_attributes(:pending => false)

        # Then, we notify that a new user has joined the project
        if @notification.save
          user_ids = User.joins(:collaborators).where(:collaborators => { :project_id => @notification.project.id, :status => "accepted" }).where.not(:collaborators => { :user_id => @notification.user_id }).ids
          user_ids.push(@notification.project.author.id)
          notification_text = @notification.user.email + " has joined " + @notification.project.name
          create_notifications(user_ids, "new_user", notification_text, @notification.project.id)
        end
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def deny
    @notification = Notification.find(params[:id])

    if @notification.user_id == current_user.id && @notification.pending && @notification.notification_type == "invitation"
      collaborator = Collaborator.where(:project_id => @notification.project_id).where(:user_id => current_user.id).where(:status => "pending").first

      if !collaborator.nil?
        collaborator.update_attribute(:status, "denied")
        @notification.update_attributes(:pending => false)
        @notification.save
      end
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
