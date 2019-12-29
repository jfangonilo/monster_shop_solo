require 'rails_helper'

RSpec.describe "admin merchants show page" do
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    @user = create(:random_user)
    @merchant = create(:random_merchant)
    @item = create(:random_item, merchant: @merchant)
    @order = create(:random_order, user: @user)
    create(:item_order, item: @item, order: @order, price: @item.price)
  end

  it 'shows me the merchant dash' do
    visit "/merchants"
    click_on "#{@merchant.name}"
    expect(current_path).to eq("/admin/merchants/#{@merchant.id}")
    expect(page).to have_content(@merchant.name)
    expect(page).to have_content(@merchant.address)
    expect(page).to have_content(@merchant.city)
    expect(page).to have_content(@merchant.state)
    expect(page).to have_content(@merchant.zip)
    expect(page).to have_link("Merchant Items")

    within "#order-#{@order.id}" do
      expect(page).to have_link("#{@order.id}")
      expect(page).to have_content(@order.created_at)
      expect(page).to have_content(@order.quantity_from(@merchant))
      expect(page).to have_content(@order.total_from(@merchant))
    end
  end
end
