require 'rails_helper'

describe SectionSerializer do
  it 'serialize expected fields' do
    record = create(:section)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'title' => record.title,
      'parent_id' => nil,
      'position' => 0,
      'has_text' => false
    )
  end
end
