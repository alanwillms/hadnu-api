class RecentSectionsController < ApplicationController
  def index
    paginate json: Section.recent, each_serializer: RecentSectionSerializer
  end
end
