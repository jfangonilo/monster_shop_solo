require 'rails_helper'

RSpec.describe "merchant new item page" do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_user = create(:merchant_employee, merchant: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)
  end

  it 'can be accessed from merchant item index page' do
    visit "/merchant/items"
    click_link "Add New Item"
    expect(current_path).to eq("/merchant/items/new")
  end
end
