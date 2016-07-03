class AddAttachmentBannerToCategories < ActiveRecord::Migration[5.0]
  def self.up
    change_table :categories do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :categories, :banner
  end
end
