require 'rails_helper'

describe SubjectsController do
  describe '#index' do
    it 'lists subjects' do
      subject = create(:subject)
      get :index
      expect(json_response.first).to include({
        'id' => subject.id,
        'name' => subject.name
      })
    end
  end
end
