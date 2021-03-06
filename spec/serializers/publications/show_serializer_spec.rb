require 'rails_helper'

describe Publications::ShowSerializer do
  it 'serialize expected fields' do
    record = create(:publication, title: 'Amazing Title Here!')
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-amazing-title-here",
      'title' => record.title,
      'description' => record.description,
      'created_at' => record.created_at.to_json[1..-2],
      'copyright_notice' => record.copyright_notice,
      'hits' => record.hits,
      'original_title' => record.original_title,
      'banner_url' => nil,
      'facebook_preview_url' => nil,
      'google_preview_url' => nil,
      'twitter_preview_url' => nil,
      'downloadable' => false,
      'root_section_id' => nil,
      'authors' => [],
      'sections' => [],
      'categories' => [],
      'pseudonyms' => [],
      'related' => [],
      'featured' => record.featured,
      'blocked' => record.blocked,
      'published' => record.published,
      'signed_reader_only' => record.signed_reader_only
    )
  end

  it 'display random related publications' do
    record = create(:publication)
    another = create(:publication, title: 'Another Book')
    expect(serialize(record)['related'].first).to eq(
      'id' => another.id,
      'slug' => "#{another.id}-another-book",
      'title' => another.title,
      'description' => another.description,
      'created_at' => another.created_at.to_json[1..-2],
      'banner_url' => nil,
      'facebook_preview_url' => nil,
      'google_preview_url' => nil,
      'twitter_preview_url' => nil
    )
  end
end
