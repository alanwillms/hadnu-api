PaginationType = GraphQL::ObjectType.define do
  name 'Pagination'
  description 'Pagination informations'

  field :limit_value, !types.Int
  field :total_count, !types.Int
  field :total_pages, !types.Int
  field :current_page, !types.Int
  field :next_page, types.Int
  field :prev_page, types.Int
  field :at_first_page, !types.Boolean
  field :at_last_page, !types.Boolean
  field :out_of_range, !types.Boolean
end
