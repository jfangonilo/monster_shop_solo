require 'rails_helper'

RSpec.describe "merchant items edit page" do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @item = create(:random_item, merchant: @merchant, active?: false)
  end

  it 'can be accessed from the merchant items index page' do
    visit "/merchant/items"
    within "#item-#{@item.id}" do
      click_button "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@item.id}/edit")
  end

  it "can edit an item" do
    visit "/merchant/items/#{@item.id}/edit"

    fill_in "Name", with: "fake Name"
    fill_in "Description", with: "fake Description"
    fill_in "Price", with: 1
    fill_in "Image", with: "https://images.onerichs.com/CIP/preview/thumbnail/uscm/9840"
    fill_in "Inventory", with: 1
    click_button "Update Item"

    @item.reload
    expect(@item.active?).to be(false)
    expect(@item.name).to eq("fake Name")

    expect(page).to have_content("Item updated!")
    expect(current_path).to eq("/merchant/items")
  end
end
