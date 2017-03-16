describe CommentType do
  let(:comment_type) { Schema.types['Comment'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description comment_type
    end
  end
end
