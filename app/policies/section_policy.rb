class SectionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    (record.publication.published && !record.publication.blocked) || admin_user?
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
        scope.where("publication_id IN (
          SELECT id
          FROM publications
          WHERE
            published = TRUE
            AND blocked = FALSE
        )")
      else
        scope.where("publication_id IN (
          SELECT id
          FROM publications
          WHERE
            published = TRUE
            AND blocked = FALSE
            AND signed_reader_only = FALSE
        )")
      end
    end
  end
end
