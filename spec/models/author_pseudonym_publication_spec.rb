require 'rails_helper'

describe AuthorPseudonymPublication do
  context 'validations' do
    before { create(:author_pseudonym_publication) }

    it { should belong_to(:author) }
    it { should belong_to(:pseudonym) }
    it { should belong_to(:publication) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:pseudonym) }
    it { should validate_presence_of(:publication) }
    it { should validate_uniqueness_of(:pseudonym).scoped_to(:publication_id) }

    it 'validates that its pseudonym belong to its author' do
      author = create(:author)
      pseudonym_of_another_author = create(:pseudonym)
      record = build(
        :author_pseudonym_publication,
        author: author,
        pseudonym: pseudonym_of_another_author
      )
      expect(record.validate).to be(false)
      expect(record.errors.messages).to eq(
        pseudonym: ['must belong to the author']
      )
    end
  end
end
