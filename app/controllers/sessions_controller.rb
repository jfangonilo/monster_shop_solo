class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      if current_admin_user
        redirect_to admin_dash_path
      elsif current_merchant_user
        redirect_to merchant_dash_path
      else
        redirect_to profile_path
      end
    end
  end
end