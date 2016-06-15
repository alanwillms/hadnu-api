require 'digest/md5'

class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :gravatar

  def gravatar
    "//www.gravatar.com/avatar/" + Digest::MD5.hexdigest(object.email)
  end
end
