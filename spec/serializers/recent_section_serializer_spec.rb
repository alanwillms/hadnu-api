require 'rails_helper'

describe RecentSectionSerializer do
  it 'serialize expected fields' do
    record = create(:section)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'title' => record.title,
      'seo_description' => record.seo_description,
      'published_at' => nil,
      'has_parent_section' => false,
      'publication' => {
        'id' => record.publication.id,
        'title' => record.publication.title,
        'description' => record.publication.description,
        'created_at' => record.publication.created_at.to_json[1..-2],
        'banner_url' => nil
      }
    )
  end
end
