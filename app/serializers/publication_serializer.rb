class PublicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :original_title, :description, :created_at, :hits,
    :copyright_notice, :banner_url, :pdf_url

  def banner_url
    publication_banner_url object if object.banner_file
  end

  def pdf_url
    publication_pdf_url object if object.pdf_file
  end
end
