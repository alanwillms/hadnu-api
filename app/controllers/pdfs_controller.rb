require 'mime/types'

class PdfsController < ApplicationController
  def show
    authorize :pdf, :show?
    show_publication_pdf if params[:publication_id]
  end

  private

  def show_publication_pdf
    publication = Publication.find(params[:publication_id])
    return unless publication && publication.pdf_file
    file_path = ENV['HADNU_PUBLICATIONS_PDFS_DIRECTORY'] + publication.pdf_file
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end
end
