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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
   
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
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

  
end
