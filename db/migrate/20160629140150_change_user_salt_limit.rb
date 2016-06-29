class ChangeUserSaltLimit < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :salt, :string, limit: 36
  end

  def down
    change_column :users, :salt, :string, limit: 13
  end
end
