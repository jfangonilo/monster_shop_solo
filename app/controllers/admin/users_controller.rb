class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def show
    @display_user = User.find(params[:id])
  end

end