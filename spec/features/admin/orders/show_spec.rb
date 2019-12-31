require 'rails_helper'

RSpec.describe "admin user order show page" do\
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    @user_1 = create(:random_user)
    @user_2 = create(:random_user, email: "user2@mail.com")
    @items = create_list(:random_item, 5)

    @order_1 = create(:random_order, user: @user_1, status: "pending")
    @items.each do |item|
      create(:item_order, item: item, order: @order_1, price: item.price)
    end

    @order_2 = create(:random_order, user: @user_2, status: "packaged")
    @items.each do |item|
      create(:item_order, item: item, order: @order_2, price: item.price)
    end

    @order_3 = create(:random_order, user: @user_1, status: "shipped")
    @items.each do |item|
      create(:item_order, item: item, order: @order_2, price: item.price)
    end

    @order_4 = create(:random_order, user: @user_2, status: "cancelled")
    @items.each do |item|
      create(:item_order, item: item, order: @order_2, price: item.price)
    end
  end

  it 'can be accessed from the admin profile view' do
    visit "/admin/users/#{@user_1.id}"
    within "#order-#{@order_1.id}" do
      expect(page).to have_link("#{@order_1.id}")
    end

    within "#order-#{@order_3.id}" do
      click_link("#{@order_3.id}")
    end
    expect(current_path).to eq("/admin/users/#{@user_1.id}/orders/#{@order_3.id}")
  end
end
