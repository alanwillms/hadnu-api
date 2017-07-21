class AddDiscussionsCountToSubjects < ActiveRecord::Migration[5.1]
  def change
    add_column :subjects, :discussions_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  private

  def data
    execute <<-SQL.squish
        UPDATE subjects
           SET discussions_count = (SELECT count(1)
                                   FROM discussions
                                  WHERE discussions.subject_id = subjects.id)
    SQL
  end
end
