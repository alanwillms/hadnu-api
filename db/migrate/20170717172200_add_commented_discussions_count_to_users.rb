class AddCommentedDiscussionsCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :commented_discussions_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
      UPDATE users
      SET commented_discussions_count = (SELECT count(DISTINCT discussion_id)
      FROM comments
      WHERE comments.user_id = users.id)
    SQL
  end
end
