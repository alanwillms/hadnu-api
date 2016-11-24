class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.random_order
    order('RANDOM()')
  end

  protected

  def set_file_from_base64(attribute, data)
    return unless data.is_a? Hash
    return unless data['base64'] && data['name']
    file = Paperclip.io_adapters.for(data['base64'])
    file.original_filename = data['name']
    send "#{attribute}=".to_sym, file
  end
end
