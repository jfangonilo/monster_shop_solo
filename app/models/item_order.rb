class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: %w(unfullfilled fullfilled)

  def subtotal
    price * quantity
  end
end
