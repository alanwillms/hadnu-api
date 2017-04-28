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

    factory :publication_with_pdf do
      pdf { File.new("#{Rails.root}/spec/support/files/document.pdf") }
    end
  end
end
