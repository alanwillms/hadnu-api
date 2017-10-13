class GraphqlController < ApplicationController
  skip_after_action :verify_authorized

  def create
    render json: Schema.execute(
      params[:query],
      {
        variables: params[:variables],
        context: { current_user: current_user, pundit: self }
      }
    )
  end
end
