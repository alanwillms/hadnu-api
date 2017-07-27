class CreatePgSearchDocumentsTriggers < ActiveRecord::Migration[5.1]
  def up
    add_column :pg_search_documents, :tsv, :tsvector
    add_index :pg_search_documents, :tsv, using: "gin"

    execute <<-SQL
    CREATE TRIGGER pg_search_documents_tsvector_update BEFORE INSERT OR UPDATE
    ON pg_search_documents FOR EACH ROW EXECUTE PROCEDURE
    tsvector_update_trigger(tsv, 'pg_catalog.portuguese', content);
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER pg_search_documents_tsvector_update
      ON pg_search_documents
    SQL

    remove_index :pg_search_documents, :tsv
    remove_column :pg_search_documents, :tsv
  end
end
