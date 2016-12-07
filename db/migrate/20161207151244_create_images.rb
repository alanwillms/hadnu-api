class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.attachment :file
      t.references :section, foreign_key: true
      t.references :publication, foreign_key: true
    end
  end
end
