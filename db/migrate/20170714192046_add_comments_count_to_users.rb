class AddCommentsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :comments_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
        UPDATE users
           SET comments_count = (SELECT count(1)
                                   FROM comments
                                  WHERE comments.user_id = users.id)
    SQL
  end
end
