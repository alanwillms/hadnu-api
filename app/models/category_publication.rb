class CategoryPublication < ApplicationRecord
  self.table_name = 'categories_publications'

  belongs_to :category
  belongs_to :publication
end
