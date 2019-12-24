FactoryBot.define do
  factory :random_user, class: User do
    name      {Faker::FunnyName.name}
    address   {Faker::Address.street_address}
    city      {Faker::Address.city}
    state     {Faker::Address.state_abbr}
    zip       {12345}
    email     {Faker::Internet.email}
    password  {"1234"}
    role      {0}
  end
end