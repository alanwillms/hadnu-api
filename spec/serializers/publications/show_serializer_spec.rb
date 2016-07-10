require 'rails_helper'

describe Publications::ShowSerializer do
  it 'serialize expected fields' do
    fail 'Impossible to implement current_user'
    record = create(:publication)
    serialization = serialization(record)
    allow(serialization.serializer.scope).to receive(:current_user).and_return(create(:user))
    data = JSON.parse(serialization.to_json)
    expect(data).to eq(
      'id' => record.id,
      'title' => record.title,
      'description' => record.description,
      'created_at' => record.created_at.to_json[1..-2],
      'banner_url' => nil
    )
  end
end
