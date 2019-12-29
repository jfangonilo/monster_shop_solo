class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle!(:active)
    flash[:success] = "#{merchant.name} disabled"
    redirect_to merchants_path
  end
end