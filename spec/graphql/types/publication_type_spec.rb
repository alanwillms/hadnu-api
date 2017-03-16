describe PublicationType do
  let(:publication_type) { Schema.types['Publication'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description publication_type
    end

    describe '#related' do
      it 'returns a list of publications' do
        create(:publication)
        publication = create(:publication)
        pundit = instance_double(Pundit)
        allow(pundit).to receive(:authorize).and_return(true)
        allow(pundit).to receive(:policy_scope).and_return(Publication)
        value = publication_type.fields['related'].resolve(
          publication,
          nil,
          pundit: pundit
        )
        expect(value.first).to be_a(Publication)
      end
    end

    describe '#downloadable' do
      it 'returns false if there is no pdf' do
        publication = build(:publication, pdf: nil)
        value = publication_type.fields['downloadable'].resolve(publication, nil, nil)
        expect(value).to be(false)
      end

      it 'returns original size URL if there is no size argument' do
        publication = instance_double(Publication)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(publication).to receive(:pdf).and_return(attachment)
        value = publication_type.fields['downloadable'].resolve(publication, nil, nil)
        expect(value).to be(true)
      end
    end

    describe '#banner_url' do
      it 'returns nil if there is no banner' do
        publication = build(:publication, banner: nil)
        url = publication_type.fields['banner_url'].resolve(publication, nil, nil)
        expect(url).to be_nil
      end

      it 'returns original size URL if there is no size argument' do
        publication = instance_double(Publication)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).and_return('http://foo/bar.jpg')
        allow(publication).to receive(:banner).and_return(attachment)
        url = publication_type.fields['banner_url'].resolve(publication, nil, nil)
        expect(url).to eq('http://foo/bar.jpg')
      end

      it 'returns resized URL if there is a valid size argument' do
        publication = instance_double(Publication)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).with(:card).and_return('http://foo/card/bar.jpg')
        allow(publication).to receive(:banner).and_return(attachment)
        url = publication_type.fields['banner_url'].resolve(
          publication,
          { size: 'card' },
          nil
        )
        expect(url).to eq('http://foo/card/bar.jpg')
      end
    end
  end
end
