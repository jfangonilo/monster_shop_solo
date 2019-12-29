class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def new
    @merchant = current_user.merchant
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

  def destroy
    item = current_user.merchant.items.find(params[:id])
    item.destroy
    flash[:success] = "#{item.name} deleted"
    redirect_to merchant_dash_items_path
  end
end