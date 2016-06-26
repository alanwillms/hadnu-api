require 'mime/types'

class BannersController < ApplicationController
  def show
    show_category_banner if params[:category_id]
  end

  private

  def show_category_banner
    category = Category.find(params[:category_id])
    file_path = ENV['HADNU_CATEGORIES_BANNER_DIRECTORY'] + category.banner_file
    mime_type = MIME::Types.type_for(file_path).first.content_type
    send_file file_path, type: mime_type, disposition: 'inline'
  end
end
