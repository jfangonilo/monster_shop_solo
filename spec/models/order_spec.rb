require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
    it { should belong_to :user }
  end

  describe 'class methods' do
    before :each do
      @user = create(:random_user)
      @order_1 = create(:random_order, status: "cancelled", user: @user)
      @order_2 = create(:random_order, status: "packaged", user: @user)
      @order_3 = create(:random_order, status: "pending", user: @user)
      @order_4 = create(:random_order, status: "shipped", user: @user)
    end

    it 'by status' do
      expect(Order.by_status).to eq([@order_2, @order_3, @order_4, @order_1])
    end
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      user = create(:random_user)
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end

    it 'quantity_from(merchant)' do
      expect(@order_1.quantity_from(@meg)).to eq(2)
      expect(@order_1.quantity_from(@brian)).to eq(3)
    end

    it 'total_from(merchant)' do
      expect(@order_1.total_from(@meg)).to eq(200)
      expect(@order_1.total_from(@brian)).to eq(30)
    end

    it 'cancel' do
      expect(@order_1.cancelled?).to be(false)
      @order_1.cancel
      expect(@order_1.cancelled?).to be(true)
      expect(@order_1.item_orders[0].unfulfilled?).to be(true)
      expect(@order_1.item_orders[1].unfulfilled?).to be(true)
    end

    it 'package if fulfilled' do
      @order_1.package_if_fulfilled
      expect(@order_1.packaged?).to be(false)

      @order_1.item_orders[0].update(status: "fulfilled")
      @order_1.package_if_fulfilled
      expect(@order_1.packaged?).to be(false)

      @order_1.item_orders[1].update(status: "fulfilled")
      @order_1.package_if_fulfilled
      expect(@order_1.packaged?).to be(true)
    end
  end
end
