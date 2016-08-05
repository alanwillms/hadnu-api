require 'rails_helper'

describe Publication do
  context 'validations' do
    before { create(:publication) }

    it { should have_and_belong_to_many(:categories) }
    it { should have_and_belong_to_many(:authors) }
    it { should have_and_belong_to_many(:pseudonyms) }
    it { should belong_to(:user) }
    it { should have_many(:sections) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:hits) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:original_title).is_at_most(255) }
    it { should validate_length_of(:copyright_notice).is_at_most(1024) }
    it { should validate_length_of(:description).is_at_most(4000) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_inclusion_of(:blocked).in_array([true, false]) }
    it { should validate_inclusion_of(:published).in_array([true, false]) }
    it { should validate_inclusion_of(:featured).in_array([true, false]) }
    it { should have_attached_file(:banner) }
    it { should have_attached_file(:pdf) }
    it { should validate_attachment_size(:banner).less_than(2.megabytes) }
    it { should validate_attachment_size(:pdf).less_than(30.megabytes) }
    it do
      should validate_numericality_of(:hits)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
    it do
      should validate_attachment_content_type(:banner)
        .allowing('image/png', 'image/gif', 'image/jpg')
        .rejecting('text/plain', 'text/xml')
    end
    it do
      should validate_attachment_content_type(:pdf)
        .allowing('application/pdf')
        .rejecting('text/plain', 'image/jpg')
    end
  end

  describe '#published_at' do
    it 'returns root section published_at value if present' do
      publication = create(:publication)
      section = create(
        :root_section,
        publication: publication,
        published_at: 10.days.ago
      )
      expect(publication.published_at).to eq(section.published_at)
    end

    it 'returns publication created_at value if section published_at is nil' do
      publication = create(:publication)
      create(
        :root_section,
        publication: publication,
        published_at: nil
      )
      expect(publication.published_at).to eq(publication.created_at)
    end
  end

  describe '#root_section' do
    it 'returns section without parent associated with the publication' do
      publication = create(:publication)
      root_section = create(
        :root_section,
        publication: publication
      )
      create(
        :section,
        parent: root_section,
        root: root_section,
        publication: publication
      )
      expect(publication.root_section).to eq(root_section)
    end

    it 'returns nil if there is no root section' do
      publication = create(:publication)
      expect(publication.root_section).to be_nil
    end
  end

  describe '.recent_first' do
    it 'returns recently created first' do
      create(:publication, title: 'third', created_at: 1.hours.ago)
      create(:publication, title: 'second', created_at: 2.hours.ago)
      create(:publication, title: 'first', created_at: 3.hours.ago)

      titles = Publication.recent_first.all.map(&:title)
      expect(titles).to eq(%w(third second first))
    end
  end

  describe '.featured' do
    it 'filters by featured publications' do
      create(:publication, title: 'featured', featured: true)
      create(:publication, title: 'not featured', featured: false)
      expect(Publication.featured.all.map(&:title)).to eq(%w(featured))
    end
  end

  describe '#hit!' do
    it 'increments the hit counter' do
      publication = create(:publication, hits: 99)
      expect { publication.hit! }.to change { publication.hits }.to(100)
    end
  end
end
