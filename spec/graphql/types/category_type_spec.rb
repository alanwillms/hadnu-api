describe CategoryType do
  let(:category_type) { Schema.types['Category'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description category_type
    end

    describe '#banner_url' do
      it 'returns nil if there is no banner' do
        category = build(:category, banner_file: nil)
        url = category_type.fields['banner_url'].resolve(category, nil, nil)
        expect(url).to be_nil
      end

      it 'returns original size URL if there is no size argument' do
        category = instance_double(Category)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).and_return('http://foo/bar.jpg')
        allow(category).to receive(:banner).and_return(attachment)
        url = category_type.fields['banner_url'].resolve(category, nil, nil)
        expect(url).to eq('http://foo/bar.jpg')
      end

      it 'returns resized URL if there is a valid size argument' do
        category = instance_double(Category)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).with(:card).and_return('http://foo/card/bar.jpg')
        allow(category).to receive(:banner).and_return(attachment)
        url = category_type.fields['banner_url'].resolve(
          category,
          { size: 'card' },
          nil
        )
        expect(url).to eq('http://foo/card/bar.jpg')
      end
    end
  end
end
