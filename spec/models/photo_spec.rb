require 'active_record_spec_helper'
require 'app/models/photo'

describe Photo do
  describe 'attributes in the database' do
    let(:metadata) {
      instance_double('PhotoMetadata',
        content_type: 'image/jpeg',
        filename: 'IMG_2598.jpg',
        latitude: latitude,
        longitude: longitude,
        comment: comment,
        taken_at: taken_at,
        exif_hash: exif_hash
      )
    }
    let(:photo) { create :photo, :fixture }

    before do
      metadata_class = class_double("PhotoMetadata").as_stubbed_const
      allow(metadata_class).to receive(:new).and_return(metadata)
    end

    context 'with missing metadata' do
      let(:latitude) { nil }
      let(:longitude) { nil }
      let(:comment) { nil }
      let(:taken_at) { nil }
      let(:exif_hash) { nil }

      it 'sets as many attributes as it can' do
        expect(photo.width).to eq(50)
        expect(photo.height).to eq(50)
        expect(photo.content_type).to eq('image/jpeg')
        expect(photo.filename).to eq('IMG_2598.jpg')
        expect(photo.latitude).to be_nil
        expect(photo.longitude).to be_nil
        expect(photo.comment).to be_nil
        expect(photo.taken_at).to be_nil
        expect(photo.exif).to be_nil
      end
    end

    context 'with full metadata' do
      let(:latitude) { 39.050333333 }
      let(:longitude) { -94.6071666667 }
      let(:comment) { 'some picture' }
      let(:taken_at) { Time.zone.now.utc }
      let(:exif_hash) { {exif: 'data'} }

      it 'sets all attributes' do
        expect(photo.width).to eq(50)
        expect(photo.height).to eq(50)
        expect(photo.content_type).to eq('image/jpeg')
        expect(photo.filename).to eq('IMG_2598.jpg')
        expect(photo.latitude).to be_within(0.0001).of(39.0503)
        expect(photo.longitude).to be_within(0.00001).of(-94.60716)
        expect(photo.comment).to eq('some picture')
        expect(photo.taken_at).to eq(taken_at)
        expect(photo.exif).to eq(exif: 'data')
      end
    end
  end

  describe '#to_base64' do
    let(:photo) { build(:photo, :fixture) }
    subject { photo.to_base64 }

    it "is the binary content encoded in base64" do
      expect(subject).to eq(Base64.encode64(photo.content.read))
    end

    context "when there is no content" do
      let(:photo) { build :photo }

      it "is nil" do
        expect(subject).to be_nil
      end
    end
  end
end
