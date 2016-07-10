require 'rails_helper'

describe PublicationSerializer do
  it 'serialize expected fields' do
    record = create(:publication)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'title' => record.title,
      'description' => record.description,
      'created_at' => record.created_at.to_json[1..-2],
      'banner_url' => nil
    )
  end
end
