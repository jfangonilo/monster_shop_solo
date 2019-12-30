class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
    @items = @merchant.items
  end

  def new
    merchant = current_user.merchant
    @item = merchant.items.new(item_params)
  end

  def create
    merchant = current_user.merchant
    @item = merchant.items.new(item_params)
    if @item.save
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def toggle_status
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

private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

end