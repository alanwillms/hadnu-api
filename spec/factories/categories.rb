FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Hipster.word.capitalize} #{n}" }
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

    factory :category_with_signed_reader_only_publications do
      after(:create) do |category, _|
        create(
          :category_publication,
          category: category,
          publication: create(:publication, signed_reader_only: true)
        )
      end
    end
  end
end
