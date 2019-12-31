class Admin::OrdersController < Admin::BaseController
  def update
    order = Order.find(params[:id])
    order.update(status: "shipped")
    redirect_to admin_dash_path
  end
end