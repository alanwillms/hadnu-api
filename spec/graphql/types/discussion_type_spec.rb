describe DiscussionType do
  let(:discussion_type) { Schema.types['Discussion'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description discussion_type
    end
  end
end
