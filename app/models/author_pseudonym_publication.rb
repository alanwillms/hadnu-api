class AuthorPseudonymPublication < ApplicationRecord
  self.table_name = 'authors_pseudonyms_publications'

  belongs_to :author
  belongs_to :pseudonym
  belongs_to :publication
end
