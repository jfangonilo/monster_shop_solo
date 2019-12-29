require 'rails_helper'

RSpec.describe 'merchant user items page' do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:merchant_employee, merchant: @merchant)
    @active_item = create(:random_item, merchant: @merchant)
    @inactive_item = create(:random_item, merchant: @merchant, active?: false)

    @user = create(:random_user)
    @ordered_item = create(:random_item, merchant: @merchant)
    @order = create(:random_order, user: @user)
    create(:item_order, item: @ordered_item, order: @order, price: @ordered_item.price)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end

  it 'allows me to deactivate/activate items' do
    visit "/merchant/items"

    within "#item-#{@active_item.id}" do
      click_button "Deactivate Item"
    end
    expect(current_path).to eq("/merchant/items")
    @active_item.reload
    expect(page).to have_content "#{@active_item.name} is no longer for sale"
    expect(@active_item.active?).to be(false)

    within "#item-#{@inactive_item.id}" do
      click_button "Activate Item"
    end
    expect(current_path).to eq("/merchant/items")
    @inactive_item.reload
    expect(page).to have_content "#{@inactive_item.name} is available for sale"
    expect(@inactive_item.active?).to be(true)
  end

  it 'allows me to delete items if they dont have any orders' do
    visit "/merchant/items"

    within "#item-#{@ordered_item.id}" do
      expect(page).not_to have_button "Delete Item"
    end

    within "#item-#{@active_item.id}" do
      click_button "Delete Item"
    end
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content "#{@active_item.name} deleted"
    @merchant.reload
    visit "/merchant/items"
    expect(page).not_to have_link "#{@active_item.name}"
  end
end
