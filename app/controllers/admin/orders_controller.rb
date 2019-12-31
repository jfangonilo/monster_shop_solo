class Admin::OrdersController < Admin::BaseController

  def show
    user = User.find(params[:user_id])
    @order = user.orders.includes(items: [:merchant]).find(params[:id])
  end

  def update
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to admin_dash_path
  end

  def cancel
    user = User.find(params[:user_id])
    order = user.orders.find(params[:id])
    order.cancel
    redirect_to "/admin/users/#{user.id}/orders/#{order.id}"
  end
end