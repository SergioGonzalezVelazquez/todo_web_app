class ApplicationController < ActionController::Base
    # Set up all controllers with user authentication
    before_action :authenticate_user!
end
