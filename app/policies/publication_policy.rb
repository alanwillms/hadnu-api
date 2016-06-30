class PublicationPolicy < ApplicationPolicy
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
    (record.published && !record.blocked) || (user && user.admin?)
  end

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.where(published: true, blocked: false)
      end
    end
  end
end
