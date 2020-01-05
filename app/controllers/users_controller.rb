class UsersController < ApplicationController
  before_action :require_user, :exclude_merchant, :exclude_admin, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "You are now registered and logged in, #{@user.name}"
      redirect_to profile_path
    else
      flash_errors(@user)
      redirect_to register_path
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password]
      update_password
    elsif @user.update(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to profile_path
    else
      flash_errors(@user)
      render :edit
    end
  end

  def edit_password
    @user = current_user
  end

private
  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password)
  end

  def update_password
    if params[:user][:password] == params[:user][:password_confirmation]
      @user.update(user_params)
      flash[:success] = "Password Updated!"
      redirect_to profile_path
    else
      flash[:error] = "Passwords don't match!"
      redirect_to profile_edit_password_path
    end
  end
end