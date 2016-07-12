class Pseudonym < ApplicationRecord
  belongs_to :author
  belongs_to :user

  validates :author, presence: true
  validates :user, presence: true
  validates :name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { scope: :author_id }
end
