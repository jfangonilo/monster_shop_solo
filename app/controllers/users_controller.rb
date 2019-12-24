class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    redirect_to '/profile'
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end