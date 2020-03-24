class UsersController < ApplicationController

  # allows the two methods to skip the authorized method requirement
  skip_before_action :authorized, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    # create a user instance
    @user = User.create(user_params) 
    
    session[:user_id] = @user.id
    
    if @user.save
      redirect_to '/tasks'
    else 
      render '/users/new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
           
    redirect_to '/'
  end

  def user_params
    params.require(:user).permit(:first_name, :surname, :email, :username,         
    :password, :password_confirmation)
  end

  
end
