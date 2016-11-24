FactoryGirl.define do
  factory :pseudonym do
    name { Faker::Name.name }
    author
    user

    factory :pseudonym_with_publications do
      after(:create) do |pseudonym, _|
        create(
          :author_pseudonym_publication,
          author: pseudonym.author, pseudonym: pseudonym
        )
      end
    end

    factory :pseudonym_with_blocked_publications do
      after(:create) do |pseudonym, _|
        create(
          :author_pseudonym_publication,
          author: pseudonym.author,
          publication: create(:publication, blocked: true),
          pseudonym: pseudonym
        )
      end
    end

    factory :pseudonym_with_unpublished_publications do
      after(:create) do |pseudonym, _|
        create(
          :author_pseudonym_publication,
          author: pseudonym.author,
          publication: create(:publication, published: false),
          pseudonym: pseudonym
        )
      end
    end
  end
end
