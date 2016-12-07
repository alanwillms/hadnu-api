class ImagesController < ApplicationController
  before_action :authenticate_user, only: :create

  def show
    skip_authorization
    extension = (params[:format] || params[:extension]).to_s
    file_name = params[:id].to_s.split('/').last.split('\\').last + '.' + extension
    file_path = ENV['HADNU_SECTIONS_IMAGES_DIRECTORY'] + "#{publication.id}/#{section.id}/#{file_name}"
    begin
      mime_type = MIME::Types.type_for(file_name).first.content_type
      send_file file_path, type: mime_type, disposition: 'inline'
    rescue
      head 404
    end
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
      render json: {
        uploaded: 1,
        fileName: image.file_file_name,
        url: "#{request.protocol}#{request.host_with_port}#{image.file.url}",
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
    @section ||= policy_scope(Section).find(params[:section_id])
  end
end
