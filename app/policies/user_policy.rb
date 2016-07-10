class UserPolicy < ApplicationPolicy
  def show?
    authenticated_user?
  end
end
