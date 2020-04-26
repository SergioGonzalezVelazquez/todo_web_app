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
    puts "CREATE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @collaborator = Collaborator.new

    @user = User.find_by(:email => params[:user_email])

    if !@user.nil?
      # Check if user has been invited yet
      @unique = Collaborator.where(:project_id => params[:project_id]).where(:user_id => @user.id).where(:status => ["pending", "accepted"]).count

      if @unique == 0
        @collaborator.user_id = @user.id
        @collaborator.project_id = params[:project_id]

        # pending
        @collaborator.status = 0

        @collaborator.save
      else
        flash[:errors] = "User already invited"
      end
    else
      flash[:errors] = "User not found"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    puts "destroy"
    @collaborator = Collaborator.find(params[:id])
    @collaborator.destroy
    redirect_back(fallback_location: root_path)
  end
end
