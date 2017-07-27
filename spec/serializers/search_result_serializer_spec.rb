require 'rails_helper'

describe SearchResultSerializer do
  it 'serializes comment search result' do
    discussion = create(:discussion, title: 'Happy Açaí!')
    comment = create(:comment, discussion: discussion)
    record = PgSearch::Document.new(
      searchable_type: 'Comment',
      searchable_id: comment.id
    )
    record.instance_eval do
      def pg_search_highlight
        'Highlighted result'
      end
    end
    expect(serialize(record)).to eq(
      'id' => comment.id,
      'parent_slug' => "#{discussion.id}-happy-acai",
      'parent_title' => 'Happy Açaí!',
      'type' => 'Comment',
      'highlight' => 'Highlighted result',
      'slug' => nil,
      'title' => nil
    )
  end

  it 'serializes section search result' do
    publication = create(:publication, title: 'Happy Açaí!')
    section = create(:section, publication: publication, title: 'Nice Job')
    record = PgSearch::Document.new(
      searchable_type: 'Section',
      searchable_id: section.id
    )
    record.instance_eval do
      def pg_search_highlight
        'Highlighted result'
      end
    end
    expect(serialize(record)).to eq(
      'id' => section.id,
      'slug' => "#{section.id}-nice-job",
      'title' => 'Nice Job',
      'type' => 'Section',
      'highlight' => 'Highlighted result',
      'parent_slug' => "#{publication.id}-happy-acai",
      'parent_title' => 'Happy Açaí!'
    )
  end
end
