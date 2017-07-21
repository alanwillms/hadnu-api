require 'rails_helper'

describe UserSerializer do
  it 'serialize expected fields' do
    record = create(:user, login: 'ac1875')
    create(:comment, user: record)
    create(:comment, user: record)
    create(:discussion, user: record)
    record.reload
    expect(serialize(record)).to eq(
      'id' => record.id,
      'login' => record.login,
      'slug' => "#{record.id}-ac1875",
      'created_at' => record.created_at.to_json[1..-2],
      'comments_counter' => 2,
      'created_discussions_counter' => 1,
      'commented_discussions_counter' => 2,
      'photo_url' => nil,
      'photo_mini_url' => nil,
      'photo_thumb_url' => nil
    )
  end
end
