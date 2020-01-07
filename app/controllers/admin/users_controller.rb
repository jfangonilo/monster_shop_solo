class Admin::UsersController < Admin::BaseController

  def index
    @users = User.all
  end

  def show
    @display_user = User.find(params[:id])
  end

  def edit
    @display_user = User.find(params[:id])
  end

  def update
    @display_user = User.find(params[:id])
    if @display_user.update(user_params)
      flash[:success] = "Profile Updated!"
      redirect_to "/admin/users/#{@display_user.id}"
    else
      flash_errors(@display_user)
      render :edit
    end
  end

  def toggle_active
    user = User.find(params[:user_id])
    user.toggle!(:active)
    redirect_to "/admin/users"
  end

private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

end