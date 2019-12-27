include FactoryBot::Syntax::Methods

Merchant.destroy_all
Item.destroy_all
Review.destroy_all
User.destroy_all
Order.destroy_all
ItemOrder.destroy_all

merchants = create_list(:random_merchant, 4)

items_0 = create_list(:random_item, 7, merchant: merchants[0])
items_0_inactive = create_list(:random_item, 3, merchant: merchants[0], active?: false)

items_1 = create_list(:random_item, 7, merchant: merchants[1])
items_1_inactive = create_list(:random_item, 3, merchant: merchants[1], active?: false)

items_2 = create_list(:random_item, 7, merchant: merchants[2])
items_2_inactive = create_list(:random_item, 3, merchant: merchants[2], active?: false)

items_3 = create_list(:random_item, 7, merchant: merchants[3])
items_3_inactive = create_list(:random_item, 3, merchant: merchants[3], active?: false)

Item.all.each do |item|
  create_list(:random_review, 5, item: item)
end

user = create(:random_user)
create(:merchant_employee)
create(:merchant_admin)
create(:admin)

order_1 = create(:random_order, user: user)
Item.all.each do |item|
  create(:item_order, order: order_1, item: item, price: item.price)
end

order_2 = create(:random_order, user: user)
Item.all.each do |item|
  create(:item_order, order: order_2, item: item, price: item.price)
end

order_3 = create(:random_order, user: user)
Item.all.each do |item|
  create(:item_order, order: order_3, item: item, price: item.price)
end

order_4 = create(:random_order, user: user)
Item.all.each do |item|
  create(:item_order, order: order_3, item: item, price: item.price)
end