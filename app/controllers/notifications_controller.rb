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

    if @notification.user_id == current_user.id && @notification.pending && @notification.notification_type == 'invitation'
      collaborator = Collaborator.where(:project_id => @notification.project_id).where(:user_id => current_user.id).where(:status => "pending").first

      if !collaborator.nil?
        collaborator.update_attribute(:status, "accepted")
        @notification.update_attributes(:pending => false)
        @notification.save
      end
    end
    redirect_back(fallback_location: root_path)
  end


  def deny
    @notification = Notification.find(params[:id])

    if @notification.user_id == current_user.id && @notification.pending && @notification.notification_type == 'invitation'
      collaborator = Collaborator.where(:project_id => @notification.project_id).where(:user_id => current_user.id).where(:status => "pending").first

      if !collaborator.nil?
        collaborator.update_attribute(:status, "denied")
        @notification.update_attributes(:pending => false)
        @notification.save
      end
    end
    redirect_back(fallback_location: root_path)
  end

end
