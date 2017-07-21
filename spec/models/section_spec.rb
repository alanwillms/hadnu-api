require 'rails_helper'

describe Section do
  context 'validations' do
    before { create(:section) }

    it { should belong_to(:publication) }
    it { should belong_to(:user) }
    it { should belong_to(:parent) }
    it { should belong_to(:root) }
    it { should have_many(:children) }
    it { should have_many(:images) }

    it { should validate_presence_of(:publication) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:position) }
    it { should validate_presence_of(:hits) }
    it do
      should validate_numericality_of(:hits)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:position)
        .only_integer
        .is_greater_than_or_equal_to(0)
    end
    it { should validate_uniqueness_of(:title).scoped_to(:parent_id) }
    it do
      should validate_uniqueness_of(:position)
        .scoped_to([:parent_id, :publication_id])
    end
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_length_of(:seo_description).is_at_most(255) }
    it { should validate_length_of(:seo_keywords).is_at_most(255) }
    it { should validate_length_of(:source).is_at_most(255) }
    it { should allow_value('1989-07-03 22:50:00').for(:published_at) }
    it { should_not allow_value('foo').for(:published_at) }
    it { should have_attached_file(:banner) }
    it { should validate_attachment_size(:banner).less_than(2.megabytes) }
    it do
      should validate_attachment_content_type(:banner)
        .allowing('image/png', 'image/gif', 'image/jpg')
        .rejecting('text/plain', 'text/xml')
    end
  end

  describe '#next' do
    it 'returns the correct next object' do
      section = create_sections_tree
      titles = []
      while section
        titles << section.title
        section = section.next
      end
      expect(titles).to eq(sections_tree_titles)
    end
  end

  describe '#previous' do
    it 'returns the correct previous object' do
      create_sections_tree
      section = Section.last
      titles = []
      while section
        titles << section.title
        section = section.previous
      end
      expect(titles).to eq(sections_tree_titles.reverse)
    end
  end

  describe '.recent' do
    it 'returns sections with a published_at date sorted descending' do
      create(:section, title: 'third', published_at: 1.hours.ago)
      create(:section, title: 'second', published_at: 2.hours.ago)
      create(:section, title: 'first', published_at: 3.hours.ago)
      create(:section, title: 'ignored')

      expect(Section.recent.map(&:title)).to eq(%w(third second first))
    end
  end

  describe '#save' do
    context 'when it is not publication first section' do
      it 'requires parent section' do
        publication = create(:publication_with_section)
        section = build(:section, publication: publication)
        expect(section.save).to be false
        expect(section.errors).to have_key(:parent_id)
      end

      it 'sets root section' do
        publication = create(:publication)
        root = create(:section, publication: publication)
        section = build(:section, publication: publication)
        section.parent = root
        expect(section.save).to be true
        expect(section.root_id).to eq(root.id)
      end
    end

    context 'when it is publication first section' do
      it 'requires empty parent section' do
        publication = create(:publication)
        other_section = create(:section)
        section = build(:section, publication: publication)
        section.parent_id = other_section.id
        expect(section.save).to be false
        expect(section.errors).to have_key(:parent_id)
      end
    end
  end

  describe '#banner_base64=' do
    let(:section) { build(:section) }

    it 'does nothing if the value is empty' do
      expect(section).not_to receive(:banner=)
      section.banner_base64 = ''
    end

    it 'does nothing if the value is wrong' do
      expect(section).not_to receive(:banner=)
      section.banner_base64 = { 'nope' => 'nope' }
    end

    it 'sets the attachment as the received file' do
      expect(section).to receive(:banner=)
      section.banner_base64 = {
        'base64' => 'data:image/jpeg;base64,/9j/4TI9RX',
        'name' => 'file.jpg'
      }
    end
  end

  def create_sections_tree
    create_tree_item sections_tree_data
  end

  def create_tree_item(item, position = 0, parent = nil)
    params = {
      title: item[:title],
      position: position,
      parent: parent
    }
    if parent
      params[:root] = parent.root
      params[:publication] = parent.publication
      params[:user] = parent.user
    end
    section = create(:section, params)
    unless item[:children].empty?
      item[:children].each_with_index do |child, position|
        create_tree_item(child, position, section)
      end
    end
    section
  end

  def sections_tree_data
    {
      title: 'Liber ABA',
      children: [
        {
          title: 'Part I Yoga',
          children: [
            { title: 'A Note', children: [] },
            { title: 'Preliminary Remarks', children: [] },
            { title: 'Chapter I Asana', children: [] },
            { title: 'Chapter II Pranayama', children: [] },
            { title: 'Chapter III Yama and Niyama', children: [] },
            { title: 'Chapter IV Pratyahara', children: [] },
            { title: 'Chapter V Dharana', children: [] },
            { title: 'Chapter VI dhyana', children: [] },
            { title: 'Chapter VII Samadhi', children: [] },
            { title: 'Summary', children: [] }
          ]
        },
        {
          title: 'Part II Theory',
          children: [
            { title: 'Chapter I the temple', children: [] },
            { title: 'Chapter II the circle', children: [] },
            { title: 'Chapter III the altar', children: [] },
            { title: 'Chapter IV the scourge', children: [] },
            { title: 'Chapter V the holy oil', children: [] },
            { title: 'Chapter VI the wand', children: [] },
            { title: 'Chapter VII the cup', children: [] },
            { title: 'An Interlude', children: [] },
            { title: 'Chapter VIII the sword', children: [] },
            { title: 'Chapter IX the pantacle', children: [] },
            { title: 'Chapter X the lamp', children: [] },
            { title: 'Chapter XI the crown', children: [] },
            { title: 'Chapter XII the robe', children: [] },
            { title: 'Chapter XIII the book', children: [] },
            { title: 'Chapter XIV the bell', children: [] },
            { title: 'Chapter XV the lamen', children: [] },
            { title: 'Chapter XVI the magick fire', children: [] },
            { title: 'Notice', children: [] }
          ]
        },
        {
          title: 'Part III Magick',
          children: [
            { title: '0 The Magical Theory of the Universe', children: [] },
            { title: 'I The Principles of Ritual', children: [] },
            { title: 'II The Formulae of the Elemental Weapons', children: [] },
            { title: 'III The Formula of Tetragrammaton', children: [] },
            { title: 'IV The Formula of Alhim', children: [] },
            { title: 'V The Formula of IAO', children: [] },
            { title: 'VI The Formula of the Neophyte', children: [] },
            { title: 'VII The Formula of the Holy Graal', children: [] },
            { title: 'VIII Of Equilibrium', children: [] },
            { title: 'IX Of Silence and Secrecy', children: [] },
            { title: 'X Of the Gestures', children: [] },
            { title: 'XI Of Our Lady BABALON and of The Beast', children: [] },
            { title: 'XII Of the Bloody Sacrifice', children: [] },
            { title: 'XIII Of the Banishings, and of the Purifications', children: [] },
            { title: 'XIV Of the Consecrations', children: [] },
            { title: 'XVI (1) Of the Oath', children: [] },
            { title: 'XV Of the Invocation', children: [] },
            { title: 'XVI (2) Of the Charge to the Spirit', children: [] },
            { title: 'XVII Of the License to Depart', children: [] },
            { title: 'XVIII Of Clairvoyance', children: [] },
            { title: 'XIX Of Dramatic Rituals', children: [] },
            { title: 'XX Of the Eucharist', children: [] },
            { title: 'XXI Of Black Magick', children: [] }
          ]
        },
        {
          title: 'Part IV Law',
          children: [
            { title: 'Chapter 1: The Boyhood of Aleister Crowley', children: [] },
            { title: 'Chapter 2: Adolescence: Beginnings of Magick', children: [] },
            { title: 'Chapter 3: Beginnings of Mysticism', children: [] },
            { title: 'Chapter 4: The Sacred Magic of Abramelin the Mage.', children: [] },
            { title: 'Chapter 5: The Results of Recession', children: [] },
            { title: 'Chapter 6: The Great Revelation', children: [] },
            { title: 'Chapter 7: Remarks on the method of receiving Liber Legis', children: [] },
            { title: 'Chapter 8: Summary of the Case', children: [] }
          ]
        }
      ]
    }
  end

  def sections_tree_titles
    @sections_tree_titles ||= get_titles(sections_tree_data)
  end

  def get_titles(item)
    titles = []
    titles << item[:title]
    unless item[:children].empty?
      item[:children].each do |child|
        get_titles(child).each { |title| titles << title }
      end
    end
    titles
  end
end
