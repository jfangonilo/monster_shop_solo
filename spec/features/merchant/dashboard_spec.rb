require 'rails_helper'

RSpec.describe "Merchant::Dashboard" do
  before :each do
    @merchant = create(:random_merchant)
    @merchant_employee = create(:merchant_employee, merchant: @merchant)
    @merchant_admin = create(:merchant_admin, merchant: @merchant)
  end

  it 'shows the merchant I work for' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    visit "/merchant"

    expect(page).to have_content(@merchant.name)
    expect(page).to have_content(@merchant.address)
    expect(page).to have_content(@merchant.city)
    expect(page).to have_content(@merchant.state)
    expect(page).to have_content(@merchant.zip)
  end
end
