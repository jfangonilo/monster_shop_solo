class Merchant::OrdersController < Merchant::BaseController

  def show
    @merchant = current_user.merchant
    @order = @merchant.orders.find(params[:id])
  end

end