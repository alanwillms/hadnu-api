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
      'photo_thumb_url' => nil,
      'disabled' => false
    )
  end

  it 'serialize blocked users replacing fields' do
    record = create(:user, login: 'ac1875', blocked: true)
    serialized = serialize(record)
    expect(serialized['photo_url']).to be_nil
    expect(serialized['slug']).to eq("#{record.id}-anonimo")
    expect(serialized['login']).to eq("Anônimo #{record.id}")
    expect(serialized['disabled']).to eq(true)
  end
end
