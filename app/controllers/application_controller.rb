class ApplicationController < ActionController::Base

    before_action :authorized
    helper_method :current_user
    helper_method :logged_in?
    

    # handles the current user’s information.
    def current_user
        User.find_by(id: session[:user_id])  
    end

    # check whether user is logged in or not
    def logged_in?
        !current_user.nil?  
    end

    # run before any other action is taken.
    # unless a user is logged in, the user will always 
    # be redirected to the login page
    def authorized
        redirect_to '/login' unless logged_in?
    end 

end
