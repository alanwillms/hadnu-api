require 'rails_helper'

describe UserSerializer do
  it 'serialize expected fields' do
    record = create(:user)
    gravatar_url = [
      '//www.gravatar.com/avatar/',
      Digest::MD5.hexdigest(record.email)
    ].join
    expect(serialize(record)).to eq(
      'id' => record.id,
      'login' => record.login,
      'gravatar' => gravatar_url
    )
  end
end
