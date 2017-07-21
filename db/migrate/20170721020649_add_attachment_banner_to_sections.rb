class AddAttachmentBannerToSections < ActiveRecord::Migration[5.1]
  def self.up
    change_table :sections do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :sections, :banner
  end
end
