class AddCommentsCountToSubjects < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :comments_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
        UPDATE subjects
           SET comments_count = (SELECT count(1)
                                   FROM comments
                                   JOIN discussions ON discussions.id = comments.discussion_id
                                  WHERE discussions.subject_id = subjects.id)
    SQL
  end
end
