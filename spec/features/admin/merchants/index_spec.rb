require 'rails_helper'

RSpec.describe "admin merchant index" do
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    @user = create(:random_user)
    @merchant = create(:random_merchant)
    @item = create(:random_item, merchant: @merchant)
    @order = create(:random_order, user: @user)
    create(:item_order, item: @item, order: @order, price: @item.price)
  end

  it 'allows me to disable/enable a merchant and items' do
    visit "/merchants"

    within "#merchant-#{@merchant.id}" do
      click_button "Disable Merchant"
    end

    expect(current_path).to eq("/merchants")
    expect(page).to have_content("#{@merchant.name} disabled")
    @merchant.reload
    expect(@merchant.active).to be(false)

    @item.reload
    expect(@item.active?).to be(false)


    within "#merchant-#{@merchant.id}" do
      click_button "Enable Merchant"
    end

    expect(current_path).to eq("/merchants")
    expect(page).to have_content("#{@merchant.name} enabled")
    @merchant.reload
    expect(@merchant.active).to be(true)

    @item.reload
    expect(@item.active?).to be(true)
  end

  it 'displays the merchant city and state' do
    visit "/merchants"

    within "#merchant-#{@merchant.id}" do
      expect(page).to have_content("#{@merchant.city}")
      expect(page).to have_content("#{@merchant.state}")
    end
  end
end
