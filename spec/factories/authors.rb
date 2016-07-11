FactoryGirl.define do
  factory :author do
    real_name { Faker::Name.name }
    pen_name { Faker::Name.name }
    user

    factory :author_with_publications do
      after(:create) do |author, _|
        pseudonym = create(:pseudonym, author: author)
        create(
          :author_pseudonym_publication,
          author: author, pseudonym: pseudonym
        )
      end
    end

    factory :author_with_blocked_publications do
      after(:create) do |author, _|
        pseudonym = create(:pseudonym, author: author)
        create(
          :author_pseudonym_publication,
          author: author,
          publication: create(:publication, blocked: true),
          pseudonym: pseudonym
        )
      end
    end

    factory :author_with_unpublished_publications do
      after(:create) do |author, _|
        pseudonym = create(:pseudonym, author: author)
        create(
          :author_pseudonym_publication,
          author: author,
          publication: create(:publication, published: false),
          pseudonym: pseudonym
        )
      end
    end
  end
end
