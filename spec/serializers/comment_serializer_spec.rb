require 'rails_helper'
require 'digest/md5'

describe CommentSerializer do
  it 'serialize expected fields' do
    record = create(:comment)
    gravatar_url = [
      '//www.gravatar.com/avatar/',
      Digest::MD5.hexdigest(record.user.email)
    ].join
    expect(serialize(record)).to eq(
      'id' => record.id,
      'comment' => record.comment,
      'created_at' => record.created_at.to_json[1..-2],
      'updated_at' => record.updated_at.to_json[1..-2],
      'user' => {
        'id' => record.user.id,
        'login' => record.user.login,
        'gravatar' => gravatar_url
      }
    )
  end
end
