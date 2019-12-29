require 'rails_helper'

RSpec.describe "Merchant::Dashboard" do
  before :each do
    @user = create(:random_user)
    @my_merchant = create(:random_merchant)
    @not_my_merchant = create(:random_merchant)
    @merchant_employee = create(:merchant_employee, merchant: @my_merchant)
    @merchant_admin = create(:merchant_admin, merchant: @my_merchant)

    @my_items = create_list(:random_item, 5, merchant: @my_merchant)
    @my_order = create(:random_order, user: @user)
    @my_items.each do |item|
      create(:item_order, item: item, order: @my_order, price: item.price)
    end

    @not_my_items = create_list(:random_item, 5, merchant: @not_my_merchant)
    @not_my_order = create(:random_order, user: @user)
    @not_my_items.each do |item|
      create(:item_order, item: item, order: @not_my_order, price: item.price)
    end
  end

  it 'shows the merchant I work for' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit "/merchant"

    expect(page).to have_content(@my_merchant.name)
    expect(page).to have_content(@my_merchant.address)
    expect(page).to have_content(@my_merchant.city)
    expect(page).to have_content(@my_merchant.state)
    expect(page).to have_content(@my_merchant.zip)
  end

  it 'shows any pending orders the merchant has' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit "/merchant"

    within "#pending-orders" do
      within "#order-#{@my_order.id}" do
        expect(page).to have_link "#{@my_order.id}"
        expect(page).to have_content @my_order.created_at
        expect(page).to have_content @my_order.total_quantity
        expect(page).to have_content @my_order.total_value
      end

      within "#order-#{@not_my_order.id}" do
        expect(page).not_to have_link "#{@not_my_order.id}"
        expect(page).not_to have_content @not_my_order.created_at
        expect(page).not_to have_content @not_my_order.total_quantity
        expect(page).not_to have_content @not_my_order.total_value
      end
    end
  end
end
