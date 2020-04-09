class RegistrationsController < Devise::RegistrationsController

  # Allow users to edit their account without providing a password
  # https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-account-without-providing-a-password
  protected

  def update_resource(resource, params)
    # if you submit a blank password, it should
    # mean “don’t change the user’s current password.”
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(account_update_params)
    else
      resource.update(account_update_params)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :surname, :username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :surname, :username, :email, :password, :password_confirmation)
  end
end
