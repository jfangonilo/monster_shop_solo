require 'rails_helper'

RSpec.describe "admin dashboard" do
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

  it 'shows me all orders' do
    visit "/admin"

    within "#order-#{@order_1.id}" do
      expect(page).to have_link "#{@user_1.name}"
      expect(page).to have_content @order_1.id
      expect(page).to have_content @order_1.created_at
    end

    within "#order-#{@order_2.id}" do
      expect(page).to have_link "#{@user_2.name}"
      expect(page).to have_content @order_2.id
      expect(page).to have_content @order_2.created_at
    end

    within "#order-#{@order_3.id}" do
      expect(page).to have_link "#{@user_1.name}"
      expect(page).to have_content @order_3.id
      expect(page).to have_content @order_3.created_at
    end

    within "#order-#{@order_4.id}" do
      expect(page).to have_link "#{@user_2.name}"
      expect(page).to have_content @order_4.id
      expect(page).to have_content @order_4.created_at
    end

    within "#all-orders" do
      expect(page.all('li')[0]).to have_content(@order_2.id)
      expect(page.all('li')[1]).to have_content(@order_1.id)
      expect(page.all('li')[2]).to have_content(@order_3.id)
      expect(page.all('li')[3]).to have_content(@order_4.id)
    end
  end

  it 'lets me ship packaged orders' do
    visit "/admin"

    within "#order-#{@order_1.id}" do
      expect(page).to_not have_button "Ship Order"
    end

    within "#order-#{@order_3.id}" do
      expect(page).to_not have_button "Ship Order"
    end

    within "#order-#{@order_4.id}" do
      expect(page).to_not have_button "Ship Order"
    end

    within "#order-#{@order_2.id}" do
      click_button "Ship Order"
    end

    @order_2.reload
    expect(@order_2.shipped?).to be(true)

    visit "/admin"
    within "#order-#{@order_2.id}" do
      expect(page).to_not have_button "Ship Order"
    end
  end
end
