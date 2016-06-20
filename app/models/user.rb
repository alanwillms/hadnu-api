require 'digest/sha1'

class User < ApplicationRecord
  has_many :discussions

  def authenticate(password)
    self.encrypted_password == Digest::SHA1.hexdigest(password + self.salt)
  end

  def self.from_token_request(request)
    login = request.params["auth"] && request.params["auth"]["login"]
    active.find_by login: login
  end

  def self.active
    where(blocked: false, email_confirmed: true)
  end
end
