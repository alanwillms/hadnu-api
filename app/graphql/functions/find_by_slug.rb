class FindBySlug < GraphQL::Function
  argument :slug, !types.String

  def initialize(model_class)
    @model_class = model_class
  end

  def call(_object, arguments, context)
    record = context[:pundit].policy_scope(@model_class).find(arguments[:slug])
    context[:pundit].authorize record, :show?
    record
  end
end
