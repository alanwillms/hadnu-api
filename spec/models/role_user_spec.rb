require 'rails_helper'

describe RoleUser do
  context 'validations' do
    before { create(:role_user) }

    it { should belong_to(:user) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:role_name) }
    it { should validate_uniqueness_of(:role_name).scoped_to(:user_id) }
    it { should validate_inclusion_of(:role_name).in_array(%w(editor owner)) }
  end
end
