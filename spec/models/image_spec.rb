require 'rails_helper'

describe Image do
  context 'validations' do
    before { create(:image) }

    it { should belong_to(:publication) }
    it { should belong_to(:section) }

    it { should validate_presence_of(:publication) }
    it { should validate_presence_of(:section) }
    it { should validate_presence_of(:file) }
    it { should have_attached_file(:file) }
    it { should validate_attachment_size(:file).less_than(2.megabytes) }
    it do
      should validate_attachment_content_type(:file)
        .allowing('image/png', 'image/gif', 'image/jpg')
        .rejecting('text/plain', 'text/xml')
    end
  end
end
