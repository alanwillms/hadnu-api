class RenameDiscussionsCommentsToCommentsCounter < ActiveRecord::Migration[5.0]
  def change
    rename_column(:discussions, :comments, :comments_counter)
  end
end
