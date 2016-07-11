require 'rails_helper'

describe Author do
  context 'validations' do
    before { create(:author) }

    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:publications) }
    it { should have_many(:pseudonyms) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:pen_name) }
    it { should validate_uniqueness_of(:pen_name) }
    it { should validate_length_of(:pen_name).is_at_most(255) }
    it { should validate_length_of(:real_name).is_at_most(255) }
    it { should validate_length_of(:description).is_at_most(2000) }
    it { should allow_value('1875-10-11').for(:born_on) }
    it { should allow_value('1947-12-01').for(:passed_away_on) }
    it { should_not allow_value('foo').for(:born_on) }
    it { should_not allow_value('foo').for(:passed_away_on) }
    it { should have_attached_file(:photo) }
    it { should validate_attachment_size(:photo).less_than(2.megabytes) }
    it do
      should validate_attachment_content_type(:photo)
        .allowing('image/png', 'image/gif', 'image/jpg')
        .rejecting('text/plain', 'text/xml')
    end
  end
end
