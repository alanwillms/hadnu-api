class ImagePolicy < ApplicationPolicy
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
end
