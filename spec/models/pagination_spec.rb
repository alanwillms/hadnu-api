require 'rails_helper'

describe Pagination do
  let(:query) do
    ActiveRecord::Relation.include Kaminari::ActiveRecordRelationMethods
    ActiveRecord::Relation.include Kaminari::PageScopeMethods
    instance_double(ActiveRecord::Relation)
  end
  let(:pagination) { Pagination.new(query) }

  describe '#limit_value' do
    it 'delegates to query' do
      allow(query).to receive(:limit_value).and_return(20)
      expect(pagination.limit_value).to eq(20)
    end
  end

  describe '#total_count' do
    it 'delegates to query' do
      allow(query).to receive(:total_count).and_return(12345)
      expect(pagination.total_count).to eq(12345)
    end
  end

  describe '#total_pages' do
    it 'delegates to query' do
      allow(query).to receive(:total_pages).and_return(13)
      expect(pagination.total_pages).to eq(13)
    end
  end

  describe '#current_page' do
    it 'delegates to query' do
      allow(query).to receive(:current_page).and_return(2)
      expect(pagination.current_page).to eq(2)
    end
  end

  describe '#next_page' do
    it 'delegates to query' do
      allow(query).to receive(:next_page).and_return(3)
      expect(pagination.next_page).to eq(3)
    end
  end

  describe '#prev_page' do
    it 'delegates to query' do
      allow(query).to receive(:prev_page).and_return(1)
      expect(pagination.prev_page).to eq(1)
    end
  end

  describe '#at_first_page' do
    it 'delegates to query' do
      allow(query).to receive(:first_page?).and_return(false)
      expect(pagination.at_first_page).to eq(false)
    end
  end

  describe '#at_last_page' do
    it 'delegates to query' do
      allow(query).to receive(:last_page?).and_return(false)
      expect(pagination.at_last_page).to eq(false)
    end
  end

  describe '#out_of_range' do
    it 'delegates to query' do
      allow(query).to receive(:out_of_range?).and_return(false)
      expect(pagination.out_of_range).to eq(false)
    end
  end
end
