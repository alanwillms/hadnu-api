class UserDeactivationsController < ApplicationController
  before_action :authenticate_user
  before_action :skip_authorization

  def create
    current_user.blocked = true
    current_user.save
    render json: {}
  end
end
