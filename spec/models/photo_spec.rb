require 'spec_helper'

describe Photo do
  it 'saves the photo attributes to the database' do
    photo = create :photo, :real

    expect(photo.filename).to eq('egg_small.jpg')
    expect(photo.content_type).to eq('image/jpeg')
    expect(photo.width).to eq(40)
    expect(photo.height).to eq(38)
  end

  describe '#to_base64' do
    let(:photo) { create(:photo, :real) }
    subject { photo.to_base64 }

    it "is the binary content encoded in base64" do
      expect(subject).to eq(Base64.encode64(photo.content.read))
    end

    context "when there is no content" do
      let(:photo) { create :photo }

      it "is nil" do
        expect(subject).to be_nil
      end
    end
  end
end
