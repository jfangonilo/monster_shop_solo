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

  it 'shows all info about the order' do
    order = create(:random_order, user: @user_1)
    merchant = create(:random_merchant)

    item_1 = create(:random_item, price: 10, merchant: merchant)
    item_order_1 = create(:item_order, item: item_1, order: order, price: item_1.price, quantity: 4)

    item_2 = create(:random_item, price: 1, merchant: merchant)
    item_order_2 = create(:item_order, item: item_2, order: order, price: item_2.price, quantity: 2)

    item_3 = create(:random_item, price: 7, merchant: merchant)
    item_order_3 = create(:item_order, item: item_3, order: order, price: item_3.price, quantity: 5)

    visit "admin/users/#{@user_1.id}/orders/#{order.id}"

    expect(page).to have_content("Order ID: #{order.id}")
    expect(page).to have_content("#{order.created_at}")
    expect(page).to have_content("#{order.updated_at}")
    expect(page).to have_content("#{order.status.capitalize}")

    within "#item-#{item_1.id}" do
      expect(page).to have_content("#{item_1.name}")
      expect(page).to have_content("#{item_1.description}")
      expect(page).to have_css("img[src*='#{item_1.image}']")
      expect(page).to have_content("#{item_1.price}")
      expect(page).to have_content("#{item_order_1.quantity}")
      expect(page).to have_content("#{item_order_1.subtotal}")
    end

    within "#item-#{item_2.id}" do
      expect(page).to have_content("#{item_2.name}")
      expect(page).to have_content("#{item_2.description}")
      expect(page).to have_css("img[src*='#{item_2.image}']")
      expect(page).to have_content("#{item_2.price}")
      expect(page).to have_content("#{item_order_2.quantity}")
      expect(page).to have_content("#{item_order_2.subtotal}")
    end

    within "#item-#{item_3.id}" do
      expect(page).to have_content("#{item_3.name}")
      expect(page).to have_content("#{item_3.description}")
      expect(page).to have_css("img[src*='#{item_3.image}']")
      expect(page).to have_content("#{item_3.price}")
      expect(page).to have_content("#{item_order_3.quantity}")
      expect(page).to have_content("#{item_order_3.subtotal}")
    end
  end

  it 'allows me to cancel a pending order' do
    visit "/admin/users/#{@user_2.id}/orders/#{@order_4.id}"
    expect(page).not_to have_button("Cancel Order")

    visit "/admin/users/#{@user_1.id}/orders/#{@order_3.id}"
    expect(page).not_to have_button("Cancel Order")

    visit "/admin/users/#{@user_2.id}/orders/#{@order_2.id}"
    expect(page).not_to have_button("Cancel Order")

    visit "/admin/users/#{@user_1.id}/orders/#{@order_1.id}"
    click_button("Cancel Order")

    @order_1.reload
    expect(@order_1.cancelled?).to be(true)
    expect(page).not_to have_button("Cancel Order")
    expect(page).to have_content("Status: Cancelled")
  end
end
