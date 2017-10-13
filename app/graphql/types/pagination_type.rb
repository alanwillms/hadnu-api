PaginationType = GraphQL::ObjectType.define do
  name 'Pagination'
  description 'Pagination informations'

  field :limit_value, !types.Int, 'Number of records per page'
  field :total_count, !types.Int, 'Total number of records in all pages'
  field :total_pages, !types.Int, 'Number of pages'
  field :current_page, !types.Int, 'Current page number'
  field :next_page, types.Int, 'Next page number or null'
  field :prev_page, types.Int, 'Previous page number or null'
  field :at_first_page, !types.Boolean, 'If current page is the first page'
  field :at_last_page, !types.Boolean, 'If current page is the last page'
  field :out_of_range, !types.Boolean, 'If current page is out of range'
end
