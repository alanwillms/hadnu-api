class RecentSectionsController < ApplicationController
  def index
    authorize Section
    paginate json: policy_scope(Section).recent, each_serializer: RecentSectionSerializer
  end
end
