class CommentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    authenticated_user?
  end

  def update?
    return false unless authenticated_user?
    return true if admin_user?
    record.user == user && record.created_at >= 1.day.ago
  end

  def destroy?
    admin_user?
  end
end
