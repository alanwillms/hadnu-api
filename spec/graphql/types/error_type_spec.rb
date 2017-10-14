describe ErrorType do
  let(:error_type) { Schema.types['Error'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description error_type
    end
  end
end
