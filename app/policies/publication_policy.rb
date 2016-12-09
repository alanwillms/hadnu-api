class PublicationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    (record.published && !record.blocked) || admin_user?
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
        scope.where(published: true, blocked: false)
      else
        scope.where(published: true, blocked: false, signed_reader_only: false)
      end
    end
  end
end
