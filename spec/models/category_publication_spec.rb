require 'rails_helper'

describe CategoryPublication do
  context 'validations' do
    before { create(:category_publication) }

    it { should belong_to(:category) }
    it { should belong_to(:publication) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:publication) }
    it { should validate_uniqueness_of(:category).scoped_to(:publication_id) }
  end
end
