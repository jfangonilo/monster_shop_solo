class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.by_status.includes(:user)
  end
end