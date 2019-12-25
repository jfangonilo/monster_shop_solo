FactoryBot.define do
  factory :random_order, class: Order do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {Faker::Address.zip}
    # association :user, factory: :random_user
  end
end
