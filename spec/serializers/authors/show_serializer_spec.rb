require 'rails_helper'

describe Authors::ShowSerializer do
  it 'serialize expected fields' do
    author = create(
      :author,
      pen_name: 'João Maria',
      born_on: '1875-10-12',
      passed_away_on: '1947-12-01'
    )
    expect(serialize(author)).to eq(
      'id' => author.id,
      'slug' => "#{author.id}-joao-maria",
      'pen_name' => author.pen_name,
      'real_name' => author.real_name,
      'born_on' => author.born_on.to_json[1..-2],
      'passed_away_on' => author.passed_away_on.to_json[1..-2],
      'description' => author.description,
      'photo_url' => nil,
      'photo_thumb_url' => nil
    )
  end
end
