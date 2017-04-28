require 'rails_helper'

describe DownloadsController do
  describe '#show' do
    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        get :show, params: { publication_id: create(:publication).id }
        expect(response.status).to eq(401)
      end
    end

    context 'with invalid publication' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        authenticate
        get :show, params: { publication_id: 123 }
        expect(response.status).to be(404)
      end
    end

    context 'without PDF file' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        authenticate
        publication = create(:publication, pdf: nil)
        get :show, params: { publication_id: publication.id }
        expect(response.status).to be(404)
      end
    end

    context 'with valid image' do
      it 'sends the file' do
        authenticate
        publication = create(:publication_with_pdf)
        mime_type = instance_double(MIME::Type)
        allow(mime_type).to receive(:content_type).and_return('application/pdf')
        allow(mime_type).to receive(:media_type).and_return('application/pdf')
        allow(MIME::Types).to receive(:type_for).and_return([mime_type])
        expect(controller).to receive(:send_file).once
        get :show, params: { publication_id: publication.id }
      end
    end
  end
end
