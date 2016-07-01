class AuthorPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where("id IN (
          SELECT author_id
          FROM authors_pseudonyms_publications
          JOIN publications ON publications.id = publication_id
          WHERE published = TRUE AND blocked = FALSE
        )")
      end
    end
  end
end
