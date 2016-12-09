class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin_user?
  end

  def update?
    admin_user?
  end

  def destroy?
    admin_user?
  end

  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      elsif authenticated_user?
        scope.where("id IN (
          SELECT category_id
          FROM categories_publications
          JOIN publications ON publications.id = publication_id
          WHERE
            published = TRUE
            AND blocked = FALSE
        )")
      else
        scope.where("id IN (
          SELECT category_id
          FROM categories_publications
          JOIN publications ON publications.id = publication_id
          WHERE
            published = TRUE
            AND blocked = FALSE
            AND signed_reader_only = FALSE
        )")
      end
    end
  end
end
