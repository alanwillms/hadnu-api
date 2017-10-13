class FindAll < GraphQL::Function
  def initialize(model_class:, refine_query: )
    @model_class = model_class
    @refine_query_block = refine_query || proc { |query| query }
  end

  def call(object, arguments, context)
    context[:pundit].authorize @model_class, :index?
    query = context[:pundit].policy_scope(@model_class)
    @refine_query_block.call query, object, arguments, context
  end
end
