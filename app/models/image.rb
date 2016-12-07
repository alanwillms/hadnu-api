# Images uploaded for a section
class Image < ApplicationRecord
  belongs_to :section
  belongs_to :publication

  has_attached_file :file

  validates :section, presence: true
  validates :publication, presence: true
  validates :file, presence: true
  validates_attachment_content_type :file, content_type: %r{\Aimage\/.*\Z}
  validates_attachment_size :file, less_than: 2.megabytes
end
