require 'rails_helper'

describe Publications::ShowSerializer do
  it 'serialize expected fields' do
    record = create(:publication)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'title' => record.title,
      'description' => record.description,
      'created_at' => record.created_at.to_json[1..-2],
      'copyright_notice' => record.copyright_notice,
      'hits' => record.hits,
      'original_title' => record.original_title,
      'banner_url' => nil,
      'pdf_url' => nil,
      'root_section_id' => nil,
      'authors' => [],
      'sections' => []
    )
  end
end
