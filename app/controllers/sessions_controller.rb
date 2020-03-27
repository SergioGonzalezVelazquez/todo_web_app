class SessionsController < ApplicationController

  # allows these methods to skip the authorized method requirement
  skip_before_action :authorized, only: [:new, :create, :welcome]

  def new
     # User already logged in
     if session[:user_id].present?
      redirect_to '/tasks'
    end 
  end

  # find a user instance based on the username 
  # params provided by the form.
  def create
    @user = User.find_by(email: params[:email])
    
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id      
      redirect_to '/tasks'   
    else      
      flash.now[:alert] = "Invalid email or password"
      render "new"
    end 
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

end
