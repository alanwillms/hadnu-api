class AddDiscussionsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discussions_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
        UPDATE users
           SET discussions_count = (SELECT count(1)
                                   FROM discussions
                                  WHERE discussions.user_id = users.id)
    SQL
  end
end
