require 'rails_helper'

describe ImagesController do
  describe '#show' do
    let(:params) do
      image = create(:image)
      {
        publication_id: image.publication_id,
        section_id: image.section_id,
        id: image.id
      }
    end

    context 'with invalid publication' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:publication_id] = 123
        get :show, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with invalid section' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:section_id] = 123
        get :show, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with invalid image' do
      it 'has a 404 status' do
        params[:section_id] = 123
        get :show, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with valid image' do
      it 'sends the file' do
        image_params = params
        mime_type = instance_double(MIME::Type)
        allow(mime_type).to receive(:content_type).and_return('image/jpg')
        allow(mime_type).to receive(:media_type).and_return('image/jpg')
        allow(MIME::Types).to receive(:type_for).and_return([mime_type])
        expect(controller).to receive(:send_file).once
        get :show, params: image_params
      end
    end
  end

  describe '#index' do
    let(:image) { create(:image) }

    let(:params) do
      {
        publication_id: image.publication_id,
        section_id: image.section_id
      }
    end

    before(:each) do
      authenticate do |user|
        create(:role_user, user: user, role_name: 'owner')
      end
    end

    context 'with invalid publication' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:publication_id] = 123
        get :index, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with invalid section' do
      it 'raise a ActiveRecord::RecordNotFound exception' do
        params[:section_id] = 123
        get :index, params: params
        expect(response.status).to be(404)
      end
    end

    context 'with valid params' do
      it 'has a 200 status' do
        get :index, params: params
        expect(response.status).to be(200)
      end

      it 'lists images' do
        get :index, params: params
        expect(json_response.first).to include(
          'id' => image.id,
          'file_file_name' => image.file_file_name
        )
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
          'url' => "http://test.host/publications/#{image.publication_id}/sections/#{image.section_id}/images/#{image.id}"
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
        post :create, params: valid_params
        expect(response.status).to eq(401)
      end
    end
  end
end
