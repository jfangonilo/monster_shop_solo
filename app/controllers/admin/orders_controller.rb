class Admin::OrdersController < Admin::BaseController

  def show
    user = User.find(params[:user_id])
    @order = user.orders.find(params[:id])
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to admin_dash_path
  end
end