class UserPolicy < ApplicationPolicy
  def show?
    authenticated_user?
  end

  def update?
    (authenticated_user? && user.id == record.id) || admin_user?
  end
end
