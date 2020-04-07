# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  #  Looking up users to render in the index action
  def index
    @users = User.order(:email)
  end

  def new
    @user = User.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.js
    end
    
  end

  def update
    @user = User.find(params[:id])
    
    # if you submit a blank password, it should 
    # mean “don’t change the user’s current password.” 
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      flash[:notice] = "User has been updated."
      redirect_back(fallback_location: root_path)
    else
      flash.now[:alert] = "User has not been updated."
      render 'edit'
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy
           
    redirect_back(fallback_location: root_path)
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :surname, :username, :email, :password, :password_confirmation, :admin)
  end

  private
  def user_params_no_pwd
    params.require(:user).permit(:first_name, :surname, :username, :email, :admin)
  end
end
