describe PaginationType do
  let(:pagination_type) { Schema.types['Pagination'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description pagination_type
    end
  end
end
