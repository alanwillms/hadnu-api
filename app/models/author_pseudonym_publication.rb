class AuthorPseudonymPublication < ApplicationRecord
  self.table_name = 'authors_pseudonyms_publications'

  belongs_to :author
  belongs_to :pseudonym
  belongs_to :publication

  validates :author, presence: true
  validates :pseudonym, presence: true, uniqueness: { scope: :publication_id }
  validates :publication, presence: true
  validate :pseudonym_must_belong_to_author

  before_validation :set_author_if_empty

  def pseudonym_must_belong_to_author
    if author&.id != pseudonym&.author_id
      message = I18n.t('activerecord.errors.messages.must_belong_to_author')
      errors.add(:pseudonym, message)
    end
  end

  private

  def set_author_if_empty
    self.author = pseudonym.author if pseudonym && !author
  end
end
