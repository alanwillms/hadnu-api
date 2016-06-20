require 'rails_helper'

describe DiscussionsController do
  describe '#index' do
    let(:discussion) { create(:discussion) }

    it 'lists discussions' do
      discussion = create(:discussion)
      get :index
      expect(json_response.first).to include({
        'id' => discussion.id,
        'title' => discussion.title
      })
    end
  end
end
