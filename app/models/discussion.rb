class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :last_user, class_name: "User"
end
