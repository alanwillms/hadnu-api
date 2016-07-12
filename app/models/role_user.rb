class RoleUser < ApplicationRecord
  belongs_to :user
  self.table_name = 'roles_users'

  validates :user, presence: true
  validates :role_name,
            presence: true,
            uniqueness: { scope: :user_id },
            inclusion: { in: %w(owner editor) }
end
