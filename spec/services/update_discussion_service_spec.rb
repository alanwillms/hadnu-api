require 'rails_helper'

describe UpdateDiscussionService do
  let(:discussion) { create(:discussion_with_comment) }
  let(:subject) { create(:subject) }
  let(:valid_params) do
    {
      title: 'Updated title',
      comment: 'Updated comment',
      subject_id: subject.id
    }
  end

  describe '#save' do
    context 'with valid data' do
      let(:service) { UpdateDiscussionService.new(discussion, valid_params) }

      it 'updates discussion title' do
        service.save
        discussion.reload
        expect(discussion.title).to eq('Updated title')
      end

      it 'updates the comment' do
        service.save
        expect(discussion.comments.first.comment).to eq('Updated comment')
      end

      it 'updates discussion subject' do
        service.save
        discussion.reload
        expect(discussion.subject).to eq(subject)
      end

      it 'returns true' do
        expect(service.save).to be true
      end
    end

    context 'with invalid discussion data' do
      let(:service) do
        params = valid_params
        params[:title] = nil
        UpdateDiscussionService.new(discussion, params)
      end

      it 'does not update discussion title' do
        service.save
        discussion.reload
        expect(discussion.title).not_to eq('Updated title')
      end

      it 'does not update the comment' do
        service.save
        discussion.reload
        expect(discussion.comments.first.comment).not_to eq('Updated comment')
      end

      it 'does not update discussion subject' do
        service.save
        discussion.reload
        expect(discussion.subject).not_to eq(subject)
      end

      it 'returns false' do
        expect(service.save).to be false
      end
    end
  end

  context 'with invalid comment data' do
    let(:service) do
      params = valid_params
      params[:comment] = nil
      UpdateDiscussionService.new(discussion, params)
    end

    it 'does not update discussion title' do
      service.save
      discussion.reload
      expect(discussion.title).not_to eq('Updated title')
    end

    it 'does not update the comment' do
      service.save
      expect(discussion.comments.first.comment).not_to eq('Updated comment')
    end

    it 'does not update discussion subject' do
      service.save
      discussion.reload
      expect(discussion.subject).not_to eq(subject)
    end

    it 'returns false' do
      expect(service.save).to be false
    end
  end

  describe '#errors' do
    it 'returns discussion errors' do
      params = valid_params
      params[:title] = nil
      service = UpdateDiscussionService.new(discussion, params)
      service.save
      expect(service.errors).to include(:title)
    end

    it 'returns comment errors' do
      params = valid_params
      params[:comment] = nil
      service = UpdateDiscussionService.new(discussion, params)
      service.save
      expect(service.errors).to include(:comment)
    end
  end
end
