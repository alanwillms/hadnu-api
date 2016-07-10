FactoryGirl.define do
  factory :category do
    name { Faker::Hipster.word.capitalize }
    description { Faker::Hipster.sentence }

    factory :category_with_publications do
      after(:create) do |category, _|
        create(
          :category_publication,
          category: category
        )
      end
    end

    factory :category_with_blocked_publications do
      after(:create) do |category, _|
        create(
          :category_publication,
          category: category, publication: create(:publication, blocked: true)
        )
      end
    end

    factory :category_with_unpublished_publications do
      after(:create) do |category, _|
        create(
          :category_publication,
          category: category,
          publication: create(:publication, published: false)
        )
      end
    end
  end
end
