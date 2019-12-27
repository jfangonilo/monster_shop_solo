require 'rails_helper'

RSpec.describe "User Profile" do
  before :each do
    user = create(:random_user)
    items_1 = create_list(:random_item, 5)
    items_2 = create_list(:random_item, 5)

    @order_1 = create(:random_order, user: user)
    @order_2 = create(:random_order, user: user)

    items_1.each do |item|
      create(:item_order, order: @order_1, item: item, price: item.price)
    end
    items_2.each do |item|
      create(:item_order, order: @order_2, item: item, price: item.price)
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'has a link to my orders' do
    visit "/profile"
    click_link "My Orders"
    expect(current_path).to eq("/profile/orders")
  end

  it 'displays my orders' do
    visit "/profile/orders"

    within "#order-#{@order_1.id}" do
      expect(page).to have_content("Order ID: #{@order_1.id}")
      expect(page).to have_content("Created: #{@order_1.created_at}")
      expect(page).to have_content("Updated: #{@order_1.updated_at}")
      expect(page).to have_content("Status: #{@order_1.status}")
      expect(page).to have_content("Total Quantity: #{@order_1.total_quantity}")
      expect(page).to have_content("Grand Total: #{@order_1.grandtotal}")
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_content("Order ID: #{@order_2.id}")
      expect(page).to have_content("Created: #{@order_2.created_at}")
      expect(page).to have_content("Updated: #{@order_2.updated_at}")
      expect(page).to have_content("Status: #{@order_2.status}")
      expect(page).to have_content("Total Quantity: #{@order_2.total_quantity}")
      expect(page).to have_content("Grand Total: #{@order_2.grandtotal}")
    end
  end

end
