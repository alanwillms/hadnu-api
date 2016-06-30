class RoleUser < ApplicationRecord
  belongs_to :user
  self.table_name = 'roles_users'
end
