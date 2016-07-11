class CategoryPublication < ApplicationRecord
  self.table_name = 'categories_publications'

  belongs_to :category
  belongs_to :publication

  validates :category, presence: true, uniqueness: { scope: :publication_id }
  validates :publication, presence: true
end
