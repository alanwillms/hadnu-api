ApiPagination.configure do |config|
  # If you have both gems included, you can choose a paginator.
  config.paginator = :kaminari # or :will_paginate

  # By default, this is set to 'Total'
  config.total_header = 'X-Total'

  # By default, this is set to 'Per-Page'
  config.per_page_header = 'X-Per-Page'

  # Optional: set this to add a header with the current page number.
  config.page_header = 'X-Page'

  # Optional: what parameter should be used to set the page option
  config.page_param = :page
end
