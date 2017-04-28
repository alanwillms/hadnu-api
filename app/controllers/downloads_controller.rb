class DownloadsController < ApplicationController
  before_action :authenticate_user

  def show
    authorize publication
    unless publication.pdf.exists?
      render json: { error: I18n.t('actionpack.errors.record_not_found') }, status: :not_found
      return
    end
    file_path = publication.pdf.path
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end

  private

  def publication
    @publication ||= policy_scope(Publication).find(params[:publication_id])
  end
end
