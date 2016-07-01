class ImagesController < ApplicationController
  before_action :set_publication, only: :show
  before_action :set_section, only: :show

  def show
    skip_authorization
    unless @publication && @section
      raise ActiveRecord::RecordNotFound
    end
    file_name = params[:id].split('/').last.split('\\').last + '.' + params[:format]
    file_path = ENV['HADNU_SECTIONS_IMAGES_DIRECTORY'] + "#{@publication.id}/#{@section.id}/#{file_name}"
    mime_type = MIME::Types.type_for(file_name).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end

  private

  def set_publication
    @publication = policy_scope(Publication).find(params[:publication_id])
  end

  def set_section
    @section = policy_scope(Section).find(params[:section_id])
  end
end
