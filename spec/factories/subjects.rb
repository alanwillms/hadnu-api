FactoryGirl.define do
  factory :subject do
    sequence(:name) { |n| "#{Faker::Hipster.word.capitalize} #{n}" }
    label_background_color { Faker::Color.hex_color[1..-1] }
    label_text_color { Faker::Color.hex_color[1..-1] }
  end
end
