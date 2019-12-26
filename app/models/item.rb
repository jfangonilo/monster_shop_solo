class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.active_items
    where(active?: true)
  end

  def self.by_quantity_ordered(amount = nil, order = "DESC")
    Item.joins(:item_orders)
        .select("items.id, items.name, sum(item_orders.quantity) AS quantity_sold")
        .group(:id)
        .order("quantity_sold #{order}")
        .limit(amount)
  end
end
