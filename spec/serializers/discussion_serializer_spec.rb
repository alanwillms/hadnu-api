require 'rails_helper'

describe DiscussionSerializer do
  def gravatar_url(user)
    '//www.gravatar.com/avatar/' + Digest::MD5.hexdigest(user.email)
  end

  it 'serialize expected fields' do
    subject = create(:subject, name: 'Subject')
    record = create(:discussion, title: 'Happy Açaí!', subject: subject)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-happy-acai",
      'title' => record.title,
      'hits' => record.hits,
      'comments_counter' => record.comments_count,
      'created_at' => record.created_at.to_json[1..-2],
      'commented_at' => record.commented_at.to_json[1..-2],
      'closed' => record.closed,
      'user' => serializer_to_hash(UserSerializer.new(record.user)),
      'last_user' => serializer_to_hash(UserSerializer.new(record.last_user)),
      'subject' => serializer_to_hash(SubjectSerializer.new(record.subject))
    )
  end
end
