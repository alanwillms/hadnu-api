FactoryGirl.define do
  factory :subject do
    name { Faker::Hipster.word.capitalize }
    label_background_color { Faker::Color.hex_color[1..-1] }
    label_text_color { Faker::Color.hex_color[1..-1] }
  end
end
