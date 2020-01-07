require 'rails_helper'

RSpec.describe "merchant orders show page" do
  before :each do
    @merchant_1 = create(:random_merchant)
    @merchant_2 = create(:random_merchant)
    @item_1 = create(:random_item, merchant: @merchant_1, price: 2, inventory: 3)
    @item_2 = create(:random_item, merchant: @merchant_1, price: 4, inventory: 5)
    @item_3 = create(:random_item, merchant: @merchant_2, price: 7)
    @user = create(:random_user)
    @order_1 = create(:random_order, user: @user)
    @item_order_1 = create(:item_order, order: @order_1, item: @item_1, price: @item_1.price, quantity: 5)
    @item_order_2 = create(:item_order, order: @order_1, item: @item_2, price: @item_2.price, quantity: 2)
    @item_order_3 = create(:item_order, order: @order_1, item: @item_3, price: @item_3.price, quantity: 2)

    @merchant_user = create(:merchant_employee, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end

  it 'shows only items and its data that belong to my merchant' do
    visit "/merchant/orders/#{@order_1.id}"

    within ".shipping-address" do
      expect(page).to have_content("#{@order_1.name}")
      expect(page).to have_content("#{@order_1.address}")
      expect(page).to have_content("#{@order_1.city}")
      expect(page).to have_content("#{@order_1.state}")
      expect(page).to have_content("#{@order_1.zip}")
    end

    within "#item-#{@item_1.id}" do
      expect(page).to have_link("#{@item_1.name}")
      expect(page).to have_css("img[src*='#{@item_1.image}']")
      expect(page).to have_content("#{@item_1.price}")
      expect(page).to have_content("#{@item_order_1.quantity}")
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_link("#{@item_2.name}")
      expect(page).to have_css("img[src*='#{@item_2.image}']")
      expect(page).to have_content("#{@item_2.price}")
      expect(page).to have_content("#{@item_order_2.quantity}")
    end

    expect(page).not_to have_link("#{@item_3.name}")
  end

  it 'allows me to fulfill parts of an order' do
    visit "/merchant/orders/#{@order_1.id}"

    within "#item-#{@item_1.id}" do
      expect(page).not_to have_button("Fulfill Item")
      expect(page).to have_content("Insufficient Inventory")
    end

    within "#item-#{@item_2.id}" do
      click_button("Fulfill Item")
    end

    expect(current_path).to eq("/merchant/orders/#{@order_1.id}")
    expect(page).to have_content("Item Fulfilled")
    @item_order_2.reload
    @item_2.reload
    expect(@item_order_2.fulfilled?).to be(true)
    expect(@item_2.inventory).to eq(3)
  end

end
