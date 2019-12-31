class Merchant::OrdersController < Merchant::BaseController

  def show
    merchant = current_user.merchant
    @order = merchant.orders.find(params[:id])
    @item_orders = merchant.item_orders_from_order(@order)
  end

  def update
    merchant = current_user.merchant
    order = merchant.orders.find(params[:id])
    item_orders = merchant.item_orders_from_order(order)
    binding.pry
  end

end