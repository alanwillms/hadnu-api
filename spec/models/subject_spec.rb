require 'rails_helper'

describe Subject do
  context 'validations' do
    before { create(:subject) }

    it { should have_many(:discussions) }
    it { should have_many(:comments) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:label_background_color) }
    it { should validate_presence_of(:label_text_color) }
    it { should validate_uniqueness_of(:name) }
    it do
      should validate_uniqueness_of(:label_background_color)
        .case_insensitive
    end
    it { should allow_value('FF0000').for(:label_background_color) }
    it { should allow_value('FFCC33').for(:label_text_color) }
    it { should_not allow_value('F00').for(:label_background_color) }
    it { should_not allow_value('FC3').for(:label_text_color) }
    it { should_not allow_value('foo').for(:label_background_color) }
    it { should_not allow_value('bar').for(:label_text_color) }
  end
end
