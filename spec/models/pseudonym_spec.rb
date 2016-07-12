require 'rails_helper'

describe Pseudonym do
  context 'validations' do
    before { create(:pseudonym) }

    it { should belong_to(:author) }
    it { should belong_to(:user) }

    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_uniqueness_of(:name).scoped_to(:author_id) }
  end
end
