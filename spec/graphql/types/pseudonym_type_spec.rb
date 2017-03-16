describe PseudonymType do
  let(:pseudonym_type) { Schema.types['Pseudonym'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description pseudonym_type
    end
  end
end
