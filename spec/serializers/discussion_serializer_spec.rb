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
      'comments_counter' => record.comments_counter,
      'commented_at' => record.commented_at.to_json[1..-2],
      'closed' => record.closed,
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
        'slug' => "#{record.subject.id}-subject",
        'name' => record.subject.name,
        'label_background_color' => record.subject.label_background_color,
        'label_text_color' => record.subject.label_text_color,
        'discussions_counter' => 1,
        'comments_counter' => 0
      }
    )
  end
end
