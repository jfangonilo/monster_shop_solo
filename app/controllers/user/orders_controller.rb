class User::OrdersController < User::BaseController

  def new

  end

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.includes(items: [:merchant]).find(params[:id])
  end

  def create
    user = current_user
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Order Submitted"
      redirect_to profile_orders_path
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to profile_path
  end

private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
