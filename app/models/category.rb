class Category < ApplicationRecord
  has_and_belongs_to_many :publications

  has_attached_file :banner,
                    styles: { card: '630x354#' },
                    default_url: '/images/:style/missing.png'
  validates_attachment_content_type :banner, content_type: %r{\Aimage\/.*\Z}
  validates :name, presence: true
  validates :description, presence: true
end
