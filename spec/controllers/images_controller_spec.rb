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

  describe '#create' do
    let(:valid_params) do
      section = create(:section)
      {
        publication_id: section.publication_id,
        section_id: section.id,
        upload: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/image.jpg")
      }
    end

    context 'with valid data' do
      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        post :create, params: valid_params
      end

      it 'returns a 201 status' do
        expect(response.status).to eq(201)
      end

      it 'creates a new image' do
        expect(Image.count).to eq(1)
      end

      it 'outputs image data' do
        image = Image.last
        expect(json_response).to include(
          'fileName' => 'image.jpg',
          'uploaded' => 1,
          'url' => "http://test.host#{image.file.url}"
        )
      end
    end

    context 'with invalid data' do
      let(:invalid_params) do
        params = valid_params
        params[:upload] = nil
        params
      end

      before(:each) do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'owner')
        end
        post :create, params: invalid_params
      end

      it 'returns a 422 status' do
        expect(response.status).to eq(422)
      end

      it 'does not create an image' do
        expect(Image.count).to eq(0)
      end

      it 'outputs errors' do
        errors_data = {
          'uploaded' => 0,
          'error' => {'message' => "File can't be blank"}
        }
        expect(json_response).to include(errors_data)
      end
    end

    context 'with unauthenticated user' do
      it 'returns a 401 status' do
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end

    context 'with unauthorized user' do
      it 'returns a 401 status' do
        authenticate do |user|
          create(:role_user, user: user, role_name: 'editor')
        end
        expect { post :create, params: valid_params }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
