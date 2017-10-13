require 'rails_helper'

describe Category do
  context 'validations' do
    before { create(:category) }

    it { should have_and_belong_to_many(:publications) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:hits) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(2000) }
    it { should have_attached_file(:banner) }
    it { should validate_attachment_size(:banner).less_than(2.megabytes) }
    it do
      should validate_attachment_content_type(:banner)
        .allowing('image/png', 'image/gif', 'image/jpg')
        .rejecting('text/plain', 'text/xml')
    end
    it do
      should validate_numericality_of(:hits)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
  end

  describe '#slug' do
    it 'returns a slug representation of the object' do
      category = build(:category, id: 123, name: 'Açaí')
      expect(category.slug).to eq('123-acai')
    end
  end
end
