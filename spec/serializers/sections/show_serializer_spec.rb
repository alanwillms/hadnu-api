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

  it 'replace images tokens in the text' do
    original_text = '<livrourl>'
    record = create(:section, text: original_text)
    fixed_text = [
      'http://localhost:3000/publications/',
      record.publication_id.to_s,
      '/sections/',
      record.id.to_s,
      '/images/'
    ].join
    expect(serialize(record)['text']).to eq(fixed_text)
  end
end
