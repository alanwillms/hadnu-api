# frozen_string_literal: true

require 'pg_search/document'

FactoryGirl.define do
  factory :pg_search_document, class: PgSearch::Document do |f|
    f.searchable { create(:comment) }
  end
end
