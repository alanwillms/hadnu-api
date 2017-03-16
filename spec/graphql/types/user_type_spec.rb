describe UserType do
  let(:user_type) { Schema.types['User'] }

  describe '#fields' do
    it 'has no item without description' do
      expect_fields_have_description user_type
    end

    describe '#photo_url' do
      it 'returns nil if there is no photo' do
        user = build(:user, photo: nil)
        url = user_type.fields['photo_url'].resolve(user, nil, nil)
        expect(url).to be_nil
      end

      it 'returns original size URL if there is no size argument' do
        user = instance_double(User)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).and_return('http://foo/bar.jpg')
        allow(user).to receive(:photo).and_return(attachment)
        url = user_type.fields['photo_url'].resolve(user, nil, nil)
        expect(url).to eq('http://foo/bar.jpg')
      end

      it 'returns resized URL if there is a valid size argument' do
        user = instance_double(User)
        attachment = double
        allow(attachment).to receive(:exists?).and_return(true)
        allow(attachment).to receive(:url).with(:card).and_return('http://foo/card/bar.jpg')
        allow(user).to receive(:photo).and_return(attachment)
        url = user_type.fields['photo_url'].resolve(
          user,
          { size: 'card' },
          nil
        )
        expect(url).to eq('http://foo/card/bar.jpg')
      end
    end
  end
end
