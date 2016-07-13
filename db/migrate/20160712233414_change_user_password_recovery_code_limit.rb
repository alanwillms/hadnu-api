class ChangeUserPasswordRecoveryCodeLimit < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :password_recovery_code, :string, limit: 36
  end

  def down
    change_column :users, :password_recovery_code, :string, limit: 13
  end
end
