require 'rails_helper'

describe SubjectsController do
  describe '#index' do
    it 'lists subjects' do
      subject = create(:subject)
      get :index
      expect(json_response.first).to include(
        'id' => subject.id,
        'name' => subject.name
      )
    end

    it 'has a 200 status' do
      create(:subject)
      get :index
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:subject) do
        create(:subject, updated_at: 1.hour.ago)
      end

      before(:each) do
        subject
        get :index
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :index
        expect(response.status).to be(304)
      end

      it 'expires if a discussion gets updated' do
        subject.touch
        get :index
        expect(response.status).to be(200)
      end

      it 'expires if a new discussion is created' do
        create(:subject)
        get :index
        expect(response.status).to be(200)
      end
    end
  end

  describe '#show' do
    it 'display subject' do
      subject = create(:subject)
      get :show, params: { id: subject.id }
      expect(json_response).to include(
        'id' => subject.id,
        'name' => subject.name
      )
    end

    it 'has a 200 status' do
      subject = create(:subject)
      get :show, params: { id: subject.id }
      expect(response.status).to be(200)
    end

    context 'cache' do
      let(:subject) { create(:subject, updated_at: 1.hour.ago) }

      before(:each) do
        get :show, params: { id: subject.id }
        set_request_etag_headers
      end

      it 'has a 304 status' do
        get :show, params: { id: subject.id }
        expect(response.status).to be(304)
      end

      it 'expires if gets updated' do
        # Removes controller class cache
        controller.instance_variable_set(:@subject, nil)
        subject.touch
        get :show, params: { id: subject.id }
        expect(response.status).to be(200)
      end
    end
  end
end
