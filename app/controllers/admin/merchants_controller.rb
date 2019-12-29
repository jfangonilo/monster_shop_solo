class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle!(:active)
    if merchant.active
      merchant.items.update_all(active?: true)
      flash[:success] = "#{merchant.name} enabled"
    else
      merchant.items.update_all(active?: false)
      flash[:success] = "#{merchant.name} disabled"
    end
    redirect_to merchants_path
  end
end