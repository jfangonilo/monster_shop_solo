class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.order(status: :ASC)
  end
end