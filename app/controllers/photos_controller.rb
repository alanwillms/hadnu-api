class PhotosController < ApplicationController
  def show
    show_author_photo if params[:author_id]
  end

  private

  def show_author_photo
    author = Author.find(params[:author_id])
    return unless author && author.photo_file
    file_path = ENV['HADNU_AUTHORS_PHOTOS_DIRECTORY'] + author.photo_file
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end
end
