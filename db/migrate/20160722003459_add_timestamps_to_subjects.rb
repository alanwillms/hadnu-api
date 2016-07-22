class AddTimestampsToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column(:subjects, :created_at, :datetime, default: -> { 'now()' })
    add_column(:subjects, :updated_at, :datetime, default: -> { 'now()' })
  end
end
