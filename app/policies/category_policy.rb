class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    false
  end

  def update?
    false
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
          SELECT category_id
          FROM categories_publications
          JOIN publications ON publications.id = publication_id
          WHERE
            published = TRUE
            AND blocked = FALSE
        )")
      end
    end
  end
end
