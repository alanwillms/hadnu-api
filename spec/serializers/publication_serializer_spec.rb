require 'rails_helper'

describe PublicationSerializer do
  it 'serialize expected fields' do
    record = create(:publication, title: 'Some Accents: Açaí')
    expect(serialize(record)).to eq(
      'id' => record.id,
      'slug' => "#{record.id}-some-accents-acai",
      'title' => record.title,
      'description' => record.description,
      'created_at' => record.created_at.to_json[1..-2],
      'banner_url' => nil,
      'facebook_preview_url' => nil,
      'google_preview_url' => nil,
      'twitter_preview_url' => nil
    )
  end
end
