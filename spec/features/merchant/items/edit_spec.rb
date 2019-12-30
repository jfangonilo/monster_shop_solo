require 'rails_helper'

RSpec.describe "merchant items edit page" do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @item = create(:random_item, merchant: @merchant)
  end

  it 'can be accessed from the merchant items index page' do
    visit "/merchant/items"
    within "#item-#{@item.id}" do
      click_button "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@item.id}/edit")
  end
end
