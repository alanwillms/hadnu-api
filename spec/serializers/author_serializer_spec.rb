require 'rails_helper'

describe AuthorSerializer do
  it 'serialize expected fields' do
    author = create(:author)
    expect(serialize(author)).to eq(
      'id' => author.id,
      'pen_name' => author.pen_name,
      'real_name' => author.real_name,
      'photo_url' => nil,
      'photo_thumb_url' => nil
    )
  end
end
