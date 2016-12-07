FactoryGirl.define do
  factory :image do
    section
    publication
    file { File.new("#{Rails.root}/spec/support/files/image.jpg") }
  end
end
