require 'active_record_spec_helper'
require 'app/serializers/photo_session_serializer'

describe PhotoSessionSerializer do
  subject(:response_hash) { described_class.new(photo).as_json }

  let(:photo) { create :photo, :with_metadata, :uploaded }

  let(:test_session) { instance_double('BlobSession', read_attribute_for_serialization: 'test-bucket', serializable_hash: {id: 'test-bucket'}) }
  let!(:blob_session_class) { class_double('BlobSession', new: test_session).as_stubbed_const }

  it "includes photo" do
    photo_hash = PhotoSerializer.new(photo).as_json

    expect(response_hash[:photo]).to eq(photo_hash)
  end

  it "includes a blob session for the photo" do
    allow(test_session).to receive(:serializable_hash).and_return(
      id: 'test-bucket',
      session_token: 'session_token',
      access_key_id: 'access_key_id',
      secret_access_key: 'secret_access_key',
    )
    allow(test_session).to receive(:read_attribute_for_serialization) do |attribute|
      if attribute.to_s == 'id'
        'test-bucket'
      else
        attribute.to_s
      end
    end
    expect(blob_session_class).to receive(:new).with(photo.blob_bucket, photo.user)

    session_hash = BlobSessionSerializer.new(test_session).as_json

    expect(response_hash[:blob_sessions]).to eq([session_hash])
  end
end
