require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :items}
    it { should have_many(:item_orders).through(:items) }
    it { should have_many(:orders).through(:item_orders) }
    it { should have_many :users}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      user = create(:random_user)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      user = create(:random_user)
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user: user)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to match_array(["Denver","Hershey"])
    end

    it 'pending_orders' do
      user = create(:random_user)
      merchant = create(:random_merchant)
      items = create_list(:random_item, 5, merchant: merchant)

      pending_order_1 = create(:random_order, user: user, status: "pending")
      items.each do |item|
        create(:item_order, item: item, order: pending_order_1, price: item.price)
      end

      pending_order_2 = create(:random_order, user: user, status: "pending")
      items.each do |item|
        create(:item_order, item: item, order: pending_order_2, price: item.price)
      end

      shipped_order = create(:random_order, user: user, status: "shipped")
      items.each do |item|
        create(:item_order, item: item, order: shipped_order, price: item.price)
      end

      cancelled_order = create(:random_order, user: user, status: "cancelled")
      items.each do |item|
        create(:item_order, item: item, order: cancelled_order, price: item.price)
      end

      expect(merchant.pending_orders).to include(pending_order_1)
      expect(merchant.pending_orders).to include(pending_order_2)
      expect(merchant.pending_orders).not_to include(shipped_order)
      expect(merchant.pending_orders).not_to include(cancelled_order)
    end
  end
end
