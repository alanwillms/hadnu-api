require 'rails_helper'

describe DiscussionSerializer do
  def gravatar_url(user)
    '//www.gravatar.com/avatar/' + Digest::MD5.hexdigest(user.email)
  end

  it 'serialize expected fields' do
    record = create(:discussion)
    expect(serialize(record)).to eq(
      'id' => record.id,
      'title' => record.title,
      'hits' => record.hits,
      'comments_counter' => record.comments_counter,
      'commented_at' => nil,
      'user' => {
        'id' => record.user.id,
        'login' => record.user.login,
        'gravatar' => gravatar_url(record.user)
      },
      'last_user' => {
        'id' => record.last_user.id,
        'login' => record.last_user.login,
        'gravatar' => gravatar_url(record.last_user)
      },
      'subject' => {
        'id' => record.subject.id,
        'name' => record.subject.name,
        'label_background_color' => record.subject.label_background_color,
        'label_text_color' => record.subject.label_text_color
      }
    )
  end
end