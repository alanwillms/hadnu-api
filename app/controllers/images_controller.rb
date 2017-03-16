class ImagesController < ApplicationController
  before_action :authenticate_user, only: [:create, :index]

  def show
    skip_authorization
    image = section.images.find(params[:id])
    file_path = image.file.path
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end

  def index
    authorize Image
    expires_now
    render json: section.images
  end

  # CKEditor compatible
  def create
    image = Image.new
    image.publication = publication
    image.section = section
    image.file = params[:upload]

    authorize image
    expires_now

    if image.save
      section_url = publication_section_url(section.publication, section)
      render json: {
        uploaded: 1,
        fileName: image.file_file_name,
        url: "#{section_url}/images/#{image.id}",
      }, status: :created
    else
      render json: {
        uploaded: 0,
        error: {
          message: image.errors.full_messages.join("\n")
        }
      }, status: :unprocessable_entity
    end
  end

  private

  def publication
    @publication ||= policy_scope(Publication).find(params[:publication_id])
  end

  def section
    @section ||= policy_scope(publication.sections).find(params[:section_id])
  end
end
