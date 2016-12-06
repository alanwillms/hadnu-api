FactoryGirl.define do
  factory :publication do
    user
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    blocked false
    published true

    factory :publication_with_section do
      after(:create) do |publication, _|
        create(
          :section,
          publication: publication
        )
      end
    end
  end
end
