class ApplicationController < ActionController::Base
  # Set up all controllers with user authentication
  before_action :authenticate_user!

  helper_method :projects
  # Task collections must be present on all pages,
  # because they are displayed on the sidebar
  def projects
    if user_signed_in?
      #User.find_by(id: session[:user_id])
      Project.where(:author_id => current_user)
    end
  end

end
