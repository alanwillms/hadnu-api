FactoryGirl.define do
  factory :category do
    name { Faker::Hipster.word.capitalize }
    description { Faker::Hipster.sentence }

    factory :category_with_publications do
      after(:create) do |category, _|
        create(:category_publication, category: category)
      end
    end
  end
end
