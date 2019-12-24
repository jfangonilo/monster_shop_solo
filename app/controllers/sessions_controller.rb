class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      if user.merchant_employee? || user.merchant_admin?
        redirect_to "/merchant"
      else
        redirect_to profile_path
      end
    end
  end
end