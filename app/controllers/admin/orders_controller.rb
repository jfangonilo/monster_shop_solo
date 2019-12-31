class Admin::OrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:id])
    @user = User.find(params[:user_id])
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to admin_dash_path
  end
end