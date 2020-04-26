class ApplicationController < ActionController::Base
  # Set up all controllers with user authentication
  before_action :authenticate_user!


  helper_method :unread_notifications
  helper_method :last_notifications
  # Notifications must be present on all pages,
  # because they are displayed on the navbar
  def unread_notifications
    if user_signed_in?
      #User.find_by(id: session[:user_id])
      Notification.where(:user_id => current_user).where(:pending => true).order(created_at: :desc).count
    end
  end

  def last_notifications
    if user_signed_in?
      #User.find_by(id: session[:user_id])
      Notification.where(:user_id => current_user).order(created_at: :desc).limit(3)
    end
  end

end
