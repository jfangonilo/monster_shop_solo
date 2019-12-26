require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all active items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).not_to have_link(@dog_bone.name)
    end

    it "I can see a list of all of the active items and their images are links" do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_link("#{@tire.id}-image")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
        expect(page).to have_link("#{@pull_toy.id}-image")
      end

      expect(page).not_to have_link(@dog_bone.name)
      expect(page).not_to have_content(@dog_bone.description)
      expect(page).not_to have_content("Price: $#{@dog_bone.price}")
      expect(page).not_to have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).not_to have_css("img[src*='#{@dog_bone.image}']")
    end
  end

  it "can list the top and bottom 5 items by popularity" do
    user = create(:random_user)
    order = create(:random_order)
    item_1 = create(:random_item)
    item_2 = create(:random_item)
    item_3 = create(:random_item)
    item_4 = create(:random_item)
    item_5 = create(:random_item)
    item_6 = create(:random_item)
    item_7 = create(:random_item)
    item_8 = create(:random_item)
    item_9 = create(:random_item)
    item_0 = create(:random_item)

    top_5 = [item_1, item_2, item_3, item_4, item_5]
    bottom_5 = [item_6, item_7, item_8, item_9, item_0]

    top_5.each do |item|
      ItemOrder.create(item: item, order: order, price: item.price, quantity: 20)
    end

    bottom_5.each do |item|
      ItemOrder.create(item: item, order: order, price: item.price, quantity: 1)
    end

    visit "/items"
    within "#top-5" do
      expect(page).to have_content item_1.name
      expect(page).to have_content item_2.name
      expect(page).to have_content item_3.name
      expect(page).to have_content item_4.name
      expect(page).to have_content item_5.name
      expect(page).to have_content "Total Sold: 20"
    end

    within "#bottom-5" do
      expect(page).to have_content item_6.name
      expect(page).to have_content item_7.name
      expect(page).to have_content item_8.name
      expect(page).to have_content item_9.name
      expect(page).to have_content item_0.name
      expect(page).to have_content "Total Sold: 1"
    end
  end
end
