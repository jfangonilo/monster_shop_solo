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

  it 'allows me to create a new item' do
    visit "/merchant/items/new"

    name = "fake name"
    description = "fake description"
    price = 30
    inventory = 23

    fill_in "Name", with: name
    fill_in "Description", with: description
    fill_in "Price", with: price
    fill_in "Inventory", with: inventory
    click_button "Create Item"

    item = Item.last
    expect(item.name).to eq(name)
    expect(item.price).to eq(price)
    expect(item.description).to eq(description)
    expect(item.inventory).to eq(inventory)
    expect(item.active?).to be(true)

    expect(current_path).to eq("/merchant/items")
    within "#item-#{item.id}" do
      expect(page).to have_link(name)
      expect(page).to have_content(price)
      expect(page).to have_content(inventory)
      expect(page).to have_css("img[src*='#{item.image}']")
    end
  end

  it 'flashes me a message if any item details are bad' do
    visit "/merchant/items/new"

    click_button "Create Item"
    save_and_open_page
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Price can't be blank")
    expect(page).to have_content("Price is not a number")
    expect(page).to have_content("Inventory can't be blank")
    expect(page).to have_button("Create Item")

  end
end
