FactoryGirl.define do
  factory :author_pseudonym_publication do
    pseudonym
    author { pseudonym.author }
    publication
  end
end
