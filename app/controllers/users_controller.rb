class UsersController < ApplicationController

  # allows the two methods to skip the authorized method requirement
  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params) 
    
    session[:user_id] = @user.id
    
    if @user.save
      redirect_to '/tasks'
    else 
      render '/users/new'
    end
  end

  def edit
    @projects = Project.where(:user_id => session[:user_id])
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(update_profile_params)
      render '/users/edit'
    else
      Rails.logger.info(current_user.errors.inspect) 
      render '/users/edit'
    end
  end

  def edit_password
    @projects = Project.where(:user_id => session[:user_id])
  end

  def update_password
    @projects = Project.where(:user_id => session[:user_id])

    if current_user.update(update_password_params)
      session[:user_id] = nil
      redirect_to '/login'
    else
      redirect_to edit_user_path
    end
  end
   

  def destroy
    session[:user_id] = nil
    @user = User.find(params[:id])
    @user.destroy
           
    redirect_to '/login'
  end

  def user_params
    params.require(:user).permit(:first_name, :surname, :email, :username,         
    :password, :password_confirmation)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def update_profile_params
    params.require(:user).permit(:first_name, :surname, :username)
  end

  
end
