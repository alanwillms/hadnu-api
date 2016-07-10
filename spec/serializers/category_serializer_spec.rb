require 'rails_helper'

describe CategorySerializer do
  it 'serialize expected fields' do
    record = create(:category)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'name' => record.name,
      'description' => record.description,
      'banner_url' => nil
    )
  end
end
