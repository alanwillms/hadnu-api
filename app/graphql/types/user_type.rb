UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'An user'

  field :id, !types.ID
  field :login, !types.String

  # field :name, !types.String
  # field :email, !types.String
  # field :encrypted_password, !types.String
  # field :salt, !types.String
  # field :confirmation_code, types.String
  # field :password_recovery_code, types.String
  # field :last_login_ip, types.String
  # field :registration_ip, types.String
  # field :registration_ip, types.String
  # field :google_id, types.String
  # field :facebook_id, types.String
  # field :email_confirmed, !types.Bool
  # field :blocked, !types.Bool

  field :created_at, !types.String
  field :updated_at, types.String
  field :last_login_at, types.String
  field :comments_count, !types.Int
  field :discussions_count, !types.Int
  field :commented_discussions_count, !types.Int
  field :comments, types[!CommentType]

  field :photo_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.photo.url(:profile) if obj.photo.exists? }
  end

  field :photo_mini_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.photo.url(:mini) if obj.photo.exists? }
  end

  field :photo_thumb_url, types.String do
    resolve ->(obj, _args, _ctx) { obj.photo.url(:thumb) if obj.photo.exists? }
  end

  field :slug, !types.String do
    resolve(
      lambda do |obj, _args, _ctx|
        ActiveSupport::Inflector.parameterize("#{obj.id}-#{obj.login}")
      end
    )
  end
end
