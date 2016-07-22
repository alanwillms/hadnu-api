require 'rails_helper'

describe CategorySerializer do
  it 'serialize expected fields' do
    record = create(:category, name: 'Açaí')
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-acai",
      'name' => record.name,
      'description' => record.description,
      'banner_url' => nil
    )
  end
end
