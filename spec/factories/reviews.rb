FactoryBot.define do
  factory :random_review, class: Review do
    title         {Faker::Games::WorldOfWarcraft.hero}
    content       {Faker::Books::Lovecraft.paragraph}
    rating        {rand(1..5)}
    association   :item, factory: :random_item
  end
end