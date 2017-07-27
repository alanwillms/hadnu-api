class PgSearch::DocumentPolicy < ApplicationPolicy
  def index?
    true
  end

  class Scope < Scope
    def resolve
      if admin_user?
        scope.all
      elsif authenticated_user?
        scope.where("
        searchable_type <> 'Section'
        OR
        searchable_id IN (
          SELECT id
          FROM sections
          WHERE publication_id IN (
            SELECT id
            FROM publications
            WHERE
              published = TRUE
              AND blocked = FALSE
          )
        )")
      else
        scope.where("
        searchable_type <> 'Section'
        OR
        searchable_id IN (
          SELECT id
          FROM sections
          WHERE publication_id IN (
            SELECT id
            FROM publications
            WHERE
              published = TRUE
              AND blocked = FALSE
              AND signed_reader_only = FALSE
          )
        )")
      end
    end
  end
end
