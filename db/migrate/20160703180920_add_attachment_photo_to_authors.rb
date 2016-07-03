class AddAttachmentPhotoToAuthors < ActiveRecord::Migration
  def self.up
    change_table :authors do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :authors, :photo
  end
end
