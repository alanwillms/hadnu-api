class GraphqlController < ApplicationController
  skip_after_action :verify_authorized

  def create
    result = Schema.execute(
      params[:query],
      {
        variables: params[:variables],
        context: { current_user: current_user, pundit: self }
      }
    )
    render json: result
  end
end
