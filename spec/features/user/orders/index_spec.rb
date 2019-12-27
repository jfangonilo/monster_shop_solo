require 'rails_helper'

RSpec.describe "User Profile" do
  before :each do
    user = create(:random_user)
    items_1 = create_list(:random_item, 5)
    items_2 = create_list(:random_item, 5)

    order_1 = create(:random_order, user: user)
    order_2 = create(:random_order, user: user)

    items_1.each do |item|
      create(:item_order, order: order_1, item: item, price: item.price)
    end
    items_2.each do |item|
      create(:item_order, order: order_2, item: item, price: item.price)
    end

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'has a link to my orders' do
    visit "/profile"
    click_link "My Orders"
    expect(current_path).to eq("/profile/orders")
  end
end
