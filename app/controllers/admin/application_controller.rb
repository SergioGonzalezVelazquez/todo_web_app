class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin!
  
  def index
    @admin_count = User.where(:admin => true).count
    @user_count = User.where(:admin => false).count
    @tasks_count = Task.all.count
    @pending_tasks_count = Task.where(:completed => false).count
    @completed_tasks_count = Task.where(:completed => true).count
    @projects_count = Project.all.count
  end

  # Make sure admin page is only accessible to admin users
  private
  def authorize_admin!
    authenticate_user!

    unless current_user.admin?
      redirect_to root_path, alert: "You must be an admin to do that."
    end
  end

end
