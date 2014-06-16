require 'active_record_spec_helper'
require 'app/serializers/photo_serializer'

describe PhotoSerializer do
  subject(:photo_hash) { described_class.new(photo).as_json }

  let(:photo) { build(:photo, :with_metadata, :uploaded) }

  let(:blob_session) { instance_double('BlobSession', read_attribute_for_serialization: photo.blob_bucket) }
  before { class_double('BlobSession', new: blob_session).as_stubbed_const }

  it "includes id" do
    expect(photo_hash[:id]).to eq(photo.id)
  end

  it "includes filename" do
    expect(photo_hash[:filename]).to eq(photo.filename)
  end

  it "includes content_type" do
    expect(photo_hash[:content_type]).to eq(photo.content_type)
  end

  it "includes width" do
    expect(photo_hash[:width]).to eq(photo.width)
  end

  it "includes height" do
    expect(photo_hash[:height]).to eq(photo.height)
  end

  it "includes taken_at" do
    expect(photo_hash[:taken_at]).to eq(photo.taken_at)
  end

  it "includes latitude" do
    expect(photo_hash[:latitude]).to eq(photo.latitude)
  end

  it "includes longitude" do
    expect(photo_hash[:longitude]).to eq(photo.longitude)
  end

  it "includes comment" do
    expect(photo_hash[:comment]).to eq(photo.comment)
  end

  it "includes blob_bucket" do
    expect(photo_hash[:blob_bucket]).to eq(photo.blob_bucket)
  end

  it "includes blob_key" do
    expect(photo_hash[:blob_key]).to eq(photo.blob_key)
  end

  it "includes blob_session_id" do
    expect(photo_hash[:blob_session_id]).to eq(photo.blob_bucket)
  end
end
