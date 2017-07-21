require 'rails_helper'

describe Sections::ShowSerializer do
  it 'serialize expected fields' do
    record = create(:section, title: 'Foo Bar')
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-foo-bar",
      'title' => record.title,
      'parent_id' => record.parent_id,
      'position' => record.position,
      'banner_url' => nil,
      'has_text' => false,
      'next' => nil,
      'previous' => nil,
      'published_at' => record.published_at,
      'seo_description' => record.seo_description,
      'seo_keywords' => record.seo_keywords,
      'source' => record.source,
      'text' => record.text
    )
  end
end
