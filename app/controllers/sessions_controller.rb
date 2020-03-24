class SessionsController < ApplicationController

  # allows these methods to skip the authorized method requirement
  skip_before_action :authorized, only: [:new, :create, :welcome]

  def new
  end

  # find a user instance based on the username 
  # params provided by the form.
  def create
    @user = User.find_by(username: params[:username])   
    
    if @user && @user.authenticate(params[:password])
      sessions[:user_id] = @user.id      
      redirect_to '/tasks'   
    else      
      redirect_to '/login'   
    end
  end

  def login
  end

  def welcome
  end

  def page_requires_login
  end


  

end
