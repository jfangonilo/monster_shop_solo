FactoryBot.define do
  factory :random_user, class: User do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {rand.to_s[2..6].to_i}
    email     {"user@mail.com"}
    password  {"1234"}
    role      {0}
  end

  factory :merchant_employee, class: User do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {rand.to_s[2..6].to_i}
    email     {"merchant_employee@mail.com"}
    password  {"1234"}
    role      {1}
    association :merchant, factory: :random_merchant
  end

  factory :merchant_admin, class: User do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {rand.to_s[2..6].to_i}
    email     {"merchant_admin@mail.com"}
    password  {"1234"}
    role      {2}
    association :merchant, factory: :random_merchant
  end

  factory :admin, class: User do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {rand.to_s[2..6].to_i}
    email     {"admin@mail.com"}
    password  {"1234"}
    role      {3}
  end
end