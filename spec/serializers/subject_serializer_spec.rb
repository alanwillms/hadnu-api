require 'rails_helper'

describe SubjectSerializer do
  it 'serialize expected fields' do
    record = create(:subject)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'name' => record.name,
      'label_background_color' => record.label_background_color,
      'label_text_color' => record.label_text_color
    )
  end
end
