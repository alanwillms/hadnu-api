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
    admin_user?
  end

  def destroy?
    admin_user?
  end
end
