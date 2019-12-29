require 'rails_helper'

RSpec.describe 'merchant user items page' do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:merchant_employee, merchant: @merchant)
    @active_item = create(:random_item, merchant: @merchant)
    @inactive_item = create(:random_item, merchant: @merchant, active?: false)

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
end
