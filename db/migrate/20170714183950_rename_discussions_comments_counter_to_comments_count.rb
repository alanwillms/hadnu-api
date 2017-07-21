class RenameDiscussionsCommentsCounterToCommentsCount < ActiveRecord::Migration[5.1]
  def change
    rename_column :discussions, :comments_counter, :comments_count

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
        UPDATE discussions
           SET comments_count = (SELECT count(1)
                                   FROM comments
                                  WHERE comments.discussion_id = discussions.id)
    SQL
  end
end
