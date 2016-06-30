class SectionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.publication.published && !record.publication.blocked
  end

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where("publication_id IN (
          SELECT id
          FROM publications
          WHERE
            published = TRUE
            AND blocked = FALSE
        )")
      end
    end
  end
end
