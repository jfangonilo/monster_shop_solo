require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    # it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do

    it "calculate average review" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      active = create(:random_item)
      inactive = create(:random_item, active?: false)

      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      review_2 = chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      review_3 = chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      review_4 = chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      review_5 = chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      expect(chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      active = create(:random_item)
      inactive = create(:random_item, active?: false)

      review_1 = chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      review_2 = chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      review_3 = chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      review_4 = chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      review_5 = chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)

      top_three = chain.sorted_reviews(3,:desc)
      bottom_three = chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([review_1,review_2,review_5])
      expect(bottom_three).to eq([review_3,review_4,review_5])
    end

    it 'no orders' do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      active = create(:random_item)
      inactive = create(:random_item, active?: false)
      user = create(:random_user)

      expect(chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order.item_orders.create(item: chain, price: chain.price, quantity: 2)
      expect(chain.no_orders?).to eq(false)
    end
  end

  describe "class methods" do
    it "active items" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      chain = bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      active = create(:random_item)
      inactive = create(:random_item, active?: false)

      expect(Item.active_items).to match_array [chain, active]
    end

    it "by quantity ordered" do
      user = create(:random_user)
      order = create(:random_order, user: user)
      top_5 = create_list(:random_item, 5)
      bottom_5 = create_list(:random_item, 5)

      top_5.each do |item|
        ItemOrder.create(item: item, order: order, price: item.price, quantity: 20)
      end

      bottom_5.each do |item|
        ItemOrder.create(item: item, order: order, price: item.price, quantity: 1)
      end

      expect(Item.by_quantity_ordered(5, "DESC")).to match_array(top_5)
      expect(Item.by_quantity_ordered(5, "ASC")).to match_array(bottom_5)
    end
  end
end
