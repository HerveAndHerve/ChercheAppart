class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"])

    if @user.persisted?

      auth = request.env['omniauth.auth']

      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
