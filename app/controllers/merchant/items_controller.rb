class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def update
    item = Item.find(params[:id])
    item.toggle!(:active?)
    if item.active?
      flash[:success] = "#{item.name} is available for sale"
    else
      flash[:error] = "#{item.name} is no longer for sale"
    end
    redirect_to merchant_dash_items_path
  end
end