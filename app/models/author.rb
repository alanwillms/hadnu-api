class Author < ApplicationRecord
  has_and_belongs_to_many :publications, join_table: :authors_pseudonyms_publications
  has_attached_file :photo,
                    styles: { card: '630x354#', thumb: '100x100>' },
                    default_url: '/images/missing/author/:style.jpg'

  validates_attachment_content_type :photo, content_type: %r{\Aimage\/.*\Z}
  validates :pen_name, presence: true

  def self.random_order
    order('RANDOM()')
  end
end
