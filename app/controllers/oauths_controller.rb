class OauthsController < ApplicationController
  skip_authorization_check
  skip_before_filter :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "Welcome back #{@user.name}"
    else
      begin
        @user = create_from(provider)
        @user.activate!

        reset_session # protect from session fixation attack
        auto_login(@user)
        redirect_to user_groups_path, notice: "Welcome #{@user.name}! Start by creating your first Kit with the people you want to shop with."
      rescue Exception
        redirect_to new_user_path, alert: "Our fault! We're unable to create a user with your #{provider.humanize} account."
      end
    end
  end
end

private

def auth_params
  params.permit(:code, :provider)
end
