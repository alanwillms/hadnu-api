describe SectionType do
  let(:section_type) { Schema.types['Section'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description section_type
    end

    describe '#has_text' do
      it 'returns true when there is text' do
        section = build(:section, text: '  foo  ')
        value = section_type.fields['has_text'].resolve(section, nil, nil)
        expect(value).to be(true)
      end

      it 'returns false when there is no text' do
        section = build(:section, text: '        ')
        value = section_type.fields['has_text'].resolve(section, nil, nil)
        expect(value).to be(false)
      end
    end

    describe '#banner_url' do
      it 'returns nil if there is no banner' do
        section = build(:section, banner: nil)
        url = section_type.fields['banner_url'].resolve(section, nil, nil)
        expect(url).to be_nil
      end

      it 'returns original size URL if there is no size argument' do
        section = instance_double(Section)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).and_return('http://foo/bar.jpg')
        allow(section).to receive(:banner).and_return(attachment)
        url = section_type.fields['banner_url'].resolve(section, nil, nil)
        expect(url).to eq('http://foo/bar.jpg')
      end

      it 'returns resized URL if there is a valid size argument' do
        section = instance_double(Section)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).with(:card).and_return('http://foo/card/bar.jpg')
        allow(section).to receive(:banner).and_return(attachment)
        url = section_type.fields['banner_url'].resolve(
          section,
          { size: 'card' },
          nil
        )
        expect(url).to eq('http://foo/card/bar.jpg')
      end
    end
  end
end
