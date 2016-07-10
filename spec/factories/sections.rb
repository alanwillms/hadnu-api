FactoryGirl.define do
  factory :section do
    title { Faker::Book.title }
    publication

    factory :blocked_section do
      publication { create(:publication, blocked: true) }
    end

    factory :unpublished_section do
      publication { create(:publication, published: false) }
    end
  end
end
