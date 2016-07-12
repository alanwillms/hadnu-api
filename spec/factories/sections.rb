FactoryGirl.define do
  factory :section do
    title { Faker::Book.title }
    publication
    user

    factory :blocked_section do
      publication { create(:publication, blocked: true) }
    end

    factory :unpublished_section do
      publication { create(:publication, published: false) }
    end

    factory :root_section do
      root_id nil
      parent_id nil
    end
  end
end
