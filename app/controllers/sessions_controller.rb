class SessionsController < ApplicationController
  def new
    if current_user
      flash[:error] = "You are already logged in"
      redirect(current_user)
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You are logged in"
      redirect(user)
    else
      flash[:error] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You are logged out"
    redirect_to "/"
  end

private

  def redirect(user)
    if current_admin_user
      redirect_to admin_dash_path
    elsif current_merchant_user
      redirect_to merchant_dash_path
    else
      redirect_to profile_path
    end
  end
end