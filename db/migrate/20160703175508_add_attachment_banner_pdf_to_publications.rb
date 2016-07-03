class AddAttachmentBannerPdfToPublications < ActiveRecord::Migration
  def self.up
    change_table :publications do |t|
      t.attachment :banner
      t.attachment :pdf
    end
  end

  def self.down
    remove_attachment :publications, :banner
    remove_attachment :publications, :pdf
  end
end
