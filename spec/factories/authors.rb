FactoryGirl.define do
  factory :author do
    real_name 'Edward Alexander Crowley'
    pen_name 'Aleister Crowley'
    user

    factory :author_with_publications do
      after(:create) do |author, _|
        create(:author_pseudonym_publication, author: author)
      end
    end
  end
end
