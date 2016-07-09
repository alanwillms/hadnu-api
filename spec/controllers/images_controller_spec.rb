require 'rails_helper'

describe ImagesController do
  describe '#show' do
    let(:params) do
      section = create(:section)
      {
        publication_id: section.publication_id,
        section_id: section.id,
        id: 'abc',
        format: 'png'
      }
    end

    context 'with invalid publication' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:publication_id] = 123
        expect { get :show, params: params }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with invalid section' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:section_id] = 123
        expect { get :show, params: params }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with invalid file' do
      it 'has a 404 status' do
        get :show, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with valid file' do
      it 'sends the file' do
        stub = instance_double(MIME::Type)
        allow(stub).to receive(:content_type).and_return('image/png')
        allow(MIME::Types).to receive(:type_for).and_return([stub])
        expect(controller).to receive(:send_file).once
        get :show, params: params
      end
    end
  end
end
