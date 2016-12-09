class AddSignedReaderOnlyToPublications < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :signed_reader_only, :boolean, default: false, null: false
  end
end
