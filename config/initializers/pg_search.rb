PgSearch.multisearch_options = {
  using: {
    tsearch: {
      dictionary: 'portuguese',
      tsvector_column: 'tsv',
      highlight: {
        start_sel: '<strong>',
        stop_sel: '</strong>',
        max_fragments: 1
      }
    }
  }
}
