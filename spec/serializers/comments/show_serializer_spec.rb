require 'rails_helper'

describe Comments::ShowSerializer do
  it 'serialize expected fields' do
    record = create(:comment)
    gravatar_url = [
      '//www.gravatar.com/avatar/',
      Digest::MD5.hexdigest(record.user.email)
    ].join
    serialized_discussion = serializer_to_hash(DiscussionSerializer.new(record.discussion))
    serialized_discussion.delete('subject')
    serialized_discussion.delete('user')
    serialized_discussion.delete('last_user')
    expect(serialize(record)).to eq(
      'id' => record.id,
      'comment' => record.comment,
      'created_at' => record.created_at.to_json[1..-2],
      'updated_at' => record.updated_at.to_json[1..-2],
      'user' => serializer_to_hash(UserSerializer.new(record.user)),
      'discussion' => serialized_discussion,
    )
  end
end
