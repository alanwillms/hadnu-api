class Pagination
  def initialize(query)
    @query = query
  end

  def limit_value
    @query.limit_value
  end

  def total_count
    @query.total_count
  end

  def total_pages
    @query.total_pages
  end

  def current_page
    @query.current_page
  end

  def next_page
    @query.next_page
  end

  def prev_page
    @query.prev_page
  end

  def at_first_page
    @query.first_page?
  end

  def at_last_page
    @query.last_page?
  end

  def out_of_range
    @query.out_of_range?
  end
end
