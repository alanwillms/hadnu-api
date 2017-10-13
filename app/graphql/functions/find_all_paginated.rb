require 'ostruct'

class FindAllPaginated < GraphQL::Function
  argument :per, types.Int, 'Number of records per page'
  argument :page, types.Int, 'Number of current page'

  def initialize(model_class:, items_key:, refine_query:)
    @model_class = model_class
    @items_key = items_key || :items
    @refine_query_block = refine_query || proc { |query| query }
  end

  def call(object, arguments, context)
    context[:pundit].authorize @model_class, :index?
    query = context[:pundit]
            .policy_scope(@model_class)
            .page(arguments[:page] || 1)
            .per(arguments[:per] || 20)
    query = @refine_query_block.call query, object, arguments, context

    result = { pagination: Pagination.new(query) }
    result[@items_key] = query

    OpenStruct.new(result)
  end
end
