describe AuthorType do
  let(:author_type) { Schema.types['Author'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description author_type
    end

    describe '#photo_url' do
      it 'returns nil if there is no photo' do
        author = build(:author, photo_file: nil)
        url = author_type.fields['photo_url'].resolve(author, nil, nil)
        expect(url).to be_nil
      end

      it 'returns original size URL if there is no size argument' do
        author = instance_double(Author)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).and_return('http://foo/bar.jpg')
        allow(author).to receive(:photo).and_return(attachment)
        url = author_type.fields['photo_url'].resolve(author, nil, nil)
        expect(url).to eq('http://foo/bar.jpg')
      end

      it 'returns resized URL if there is a valid size argument' do
        author = instance_double(Author)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).with(:card).and_return('http://foo/card/bar.jpg')
        allow(author).to receive(:photo).and_return(attachment)
        url = author_type.fields['photo_url'].resolve(
          author,
          { size: 'card' },
          nil
        )
        expect(url).to eq('http://foo/card/bar.jpg')
      end
    end
  end
end
