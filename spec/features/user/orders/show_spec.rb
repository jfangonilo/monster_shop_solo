require 'rails_helper'

RSpec.describe "order show page" do
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

  it 'shows one of my orders' do
    visit "/profile/orders"
    click_link "#{@order_1.id}"

    expect(current_path).to eq "/profile/orders/#{@order_1.id}"
    expect(page).to have_content "Order ID: #{@order_1.id}"
    expect(page).to have_content "Created: #{@order_1.created_at}"
    expect(page).to have_content "Updated: #{@order_1.updated_at}"
    expect(page).to have_content "Total Items: #{@order_1.total_quantity}"
    expect(page).to have_content "Total:"
  end
end
