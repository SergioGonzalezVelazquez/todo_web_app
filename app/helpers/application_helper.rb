module ApplicationHelper
    
    # If current_user is an admin, the method should run the code in 
    # the block; if they’re not, it should show nothing. 
    def admins_only(&block)
        block.call if current_user.try(:admin?)
    end
end
