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

  private
  def user_params
    params.require(:user).permit(:first_name, :surname, :username, :email, :password, :password_confirmation, :admin)
  end
end
