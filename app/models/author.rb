# frozen_string_literal: true

# An author owns Publications which are written under one or more
# of his Pseudonyms
class Author < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :publications,
                          join_table: :authors_pseudonyms_publications
  has_many :pseudonyms
  has_attached_file :photo,
                    styles: { card: '630x354#', thumb: '100x100#' },
                    default_url: '/images/missing/author/:style.jpg',
                    convert_options: {
                      card: '-quality 85 -strip',
                      thumb: '-quality 85 -strip'
                    }

  validates :user, presence: true
  validates :pen_name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false }
  validates :real_name, length: { maximum: 255 }
  validates :description, length: { maximum: 2000 }
  validates :born_on, date: true, allow_nil: true
  validates :passed_away_on, date: true, allow_nil: true
  validates_attachment_content_type :photo, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :photo, less_than: 2.megabytes

  def photo_base64=(data)
    set_file_from_base64(:photo, data)
  end

  def slug
    ActiveSupport::Inflector.parameterize("#{id}-#{pen_name}")
  end
end
