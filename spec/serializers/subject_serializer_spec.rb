require 'rails_helper'

describe SubjectSerializer do
  it 'serialize expected fields' do
    record = create(:subject, name: 'Açafrão')
    discussion = create(:discussion, subject: record)
    5.times { create(:comment, discussion: discussion) }
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-acafrao",
      'name' => record.name,
      'label_background_color' => record.label_background_color,
      'label_text_color' => record.label_text_color,
      'discussions_counter' => 1,
      'comments_counter' => 5
    )
  end
end
