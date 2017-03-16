describe QueryType do
  let(:query_type) { Schema.query }

  let(:context) do
    pundit = instance_double(Pundit)
    allow(pundit).to receive(:authorize).and_return(true)
    allow(pundit).to receive(:policy_scope) { |relation| relation }
    { pundit: pundit }
  end

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description query_type
    end
  end

  describe '#author' do
    it 'finds author by slug' do
      create(:author)
      author = create(:author)
      create(:author)
      value = query_type.fields['author'].resolve(
        nil,
        { slug: author.slug },
        context
      )
      expect(value).to eq(author)
    end
  end

  describe '#authors' do
    it 'lists all authors' do
      author = create(:author)
      value = query_type.fields['authors'].resolve(nil, nil, context)
      expect(value.first).to eq(author)
    end
  end

  describe '#category' do
    it 'finds category by slug' do
      create(:category)
      category = create(:category)
      create(:category)
      value = query_type.fields['category'].resolve(
        nil,
        { slug: category.slug },
        context
      )
      expect(value).to eq(category)
    end
  end

  describe '#categories' do
    it 'lists all categories' do
      category = create(:category)
      value = query_type.fields['categories'].resolve(nil, nil, context)
      expect(value.first).to eq(category)
    end
  end

  describe '#pseudonyms' do
    it 'lists all pseudonyms' do
      pseudonym = create(:pseudonym)
      value = query_type.fields['pseudonyms'].resolve(nil, nil, context)
      expect(value.first).to eq(pseudonym)
    end
  end

  describe '#subjects' do
    it 'lists all subjects' do
      subject = create(:subject)
      value = query_type.fields['subjects'].resolve(nil, nil, context)
      expect(value.first).to eq(subject)
    end
  end

  describe '#subject' do
    it 'finds subject by slug' do
      create(:subject)
      subject = create(:subject)
      create(:subject)
      value = query_type.fields['subject'].resolve(
        nil,
        { slug: subject.slug },
        context
      )
      expect(value).to eq(subject)
    end
  end

  describe '#discussion' do
    it 'finds discussion by slug' do
      create(:discussion)
      discussion = create(:discussion)
      create(:discussion)
      value = query_type.fields['discussion'].resolve(
        nil,
        { slug: discussion.slug },
        context
      )
      expect(value).to eq(discussion)
    end
  end

  describe '#publication' do
    it 'finds discussion by slug' do
      create(:publication)
      publication = create(:publication)
      create(:publication)
      value = query_type.fields['publication'].resolve(
        nil,
        { slug: publication.slug },
        context
      )
      expect(value).to eq(publication)
    end
  end

  describe '#user' do
    it 'finds user by slug' do
      create(:user)
      user = create(:user)
      create(:category)
      value = query_type.fields['user'].resolve(
        nil,
        { slug: user.slug },
        context
      )
      expect(value).to eq(user)
    end
  end

  describe '#paginated_discussions' do
    it 'returns a struct with a pagination key' do
      object = query_type.fields['paginated_discussions'].resolve(nil, {}, context)
      expect(object.pagination).to be_a(Pagination)
    end

    it 'returns a struct with a discussions key' do
      object = query_type.fields['paginated_discussions'].resolve(nil, {}, context)
      expect(object.discussions).to be_a(ActiveRecord::Relation)
    end

    it 'returns a struct with a discussions key containing discussions' do
      discussion = create(:discussion)
      object = query_type.fields['paginated_discussions'].resolve(nil, {}, context)
      expect(object.discussions.first).to eq(discussion)
    end

    it 'filters discussions by subject' do
      create(:discussion)
      discussion = create(:discussion)
      object = query_type.fields['paginated_discussions'].resolve(
        nil,
        { subject_slug: discussion.subject.slug },
        context
      )
      expect(object.discussions.size).to be(1)
      expect(object.discussions.first).to eq(discussion)
    end
  end

  describe '#paginated_comments' do
    it 'returns a struct with a pagination key' do
      comment = create(:comment)
      object = query_type.fields['paginated_comments'].resolve(
        nil,
        { discussion_slug: comment.discussion.slug },
        context
      )
      expect(object.pagination).to be_a(Pagination)
    end

    it 'returns a struct with a comments key' do
      comment = create(:comment)
      object = query_type.fields['paginated_comments'].resolve(
        nil,
        { discussion_slug: comment.discussion.slug },
        context
      )
      expect(object.comments).to be_a(ActiveRecord::Relation)
    end

    it 'returns a struct with a comments key containing discussion comments' do
      create(:comment)
      comment = create(:comment)
      object = query_type.fields['paginated_comments'].resolve(
        nil,
        { discussion_slug: comment.discussion.slug },
        context
      )
      expect(object.comments.size).to be(1)
      expect(object.comments.first).to eq(comment)
    end
  end

  describe '#paginated_publications' do
    it 'returns a struct with a pagination key' do
      object = query_type.fields['paginated_publications'].resolve(nil, {}, context)
      expect(object.pagination).to be_a(Pagination)
    end

    it 'returns a struct with a publications key' do
      object = query_type.fields['paginated_publications'].resolve(nil, {}, context)
      expect(object.publications).to be_a(ActiveRecord::Relation)
    end

    it 'returns a struct with a publications key containing publications' do
      publication = create(:publication)
      object = query_type.fields['paginated_publications'].resolve(nil, {}, context)
      expect(object.publications.first).to eq(publication)
    end
  end
end
