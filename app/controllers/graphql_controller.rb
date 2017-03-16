class GraphqlController < ApplicationController
  skip_after_action :verify_authorized

  def create
    result = Schema.execute(params[:query], variables: params[:variables])
    render json: result
  end
end
