describe SubjectType do
  let(:subject_type) { Schema.types['Subject'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description subject_type
    end
  end
end
