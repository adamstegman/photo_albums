require 'spec_helper'

describe Photo do
  describe 'saves the photo attributes to the database' do
    context 'for a contrived fixture photo' do
      subject { create :photo, :fixture }

      its(:filename) { should eq('flag.png') }
      its(:content_type) { should eq('image/png') }
      its(:width) { should eq(50) }
      its(:height) { should eq(50) }
      its(:latitude) { should be_nil }
      its(:longitude) { should be_nil }
      its(:comment) { should be_nil }
      its(:taken_at) { should be_now }
    end

    context 'for a real photo' do
      subject { create :photo, :real }

      its(:filename) { should eq('IMG_2598.jpg') }
      its(:content_type) { should eq('image/jpeg') }
      its(:width) { should eq(3264) }
      its(:height) { should eq(2448) }
      its(:latitude) { should be_within(0.0001).of(39.0503) }
      its(:longitude) { should be_within(0.00001).of(-94.60716) }
      its(:comment) { should be_nil }
      its(:taken_at) { should be_at('2013-05-15T01:55:54Z') }
    end
  end

  describe '#to_base64' do
    let(:photo) { create(:photo, :fixture) }
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
