FactoryBot.define do
  factory :random_merchant, class: Merchant do
    sequence(:name)   {|n| "#{Faker::TvShows::GameOfThrones.city} #{n}"}
    address           {Faker::Address.street_address}
    city              {Faker::Books::Lovecraft.location}
    state             {Faker::Address.state_abbr}
    zip               {Faker::Address.zip}
  end
end