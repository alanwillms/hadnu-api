require 'mime/types'

class BannersController < ApplicationController
  def show
    show_category_banner if params[:category_id]
    show_publication_banner if params[:publication_id]
  end

  private

  def show_category_banner
    category = Category.find(params[:category_id])
    return unless category && category.banner_file
    file_path = ENV['HADNU_CATEGORIES_BANNERS_DIRECTORY'] + category.banner_file
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end

  def show_publication_banner
    publication = Publication.find(params[:publication_id])
    return unless publication && publication.banner_file
    file_path = ENV['HADNU_PUBLICATIONS_BANNERS_DIRECTORY'] + publication.banner_file
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end
end
