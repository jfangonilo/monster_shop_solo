class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = current_user.merchant.orders.find(params[:id])
  end

end