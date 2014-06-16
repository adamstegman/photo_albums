require 'active_record_spec_helper'
require 'app/serializers/photos_sessions_serializer'

describe PhotosSessionsSerializer do
  subject(:response_hash) { described_class.new(photos).as_json }

  let(:photos) {
    create_list(:photo, 2, :uploaded) + create_list(:photo, 1, :uploaded, blob_bucket: 'other-bucket')
  }

  let(:test_session) { instance_double('BlobSession', read_attribute_for_serialization: 'test-bucket', serializable_hash: {id: 'test-bucket'}) }
  let!(:blob_session_class) { class_double('BlobSession', new: test_session).as_stubbed_const }

  it "includes photos" do
    photos_hashes = photos.map { |p| PhotoSerializer.new(p).as_json }

    expect(response_hash[:photos]).to match_array_of_hashes(photos_hashes)
  end

  it "includes sessions for each unique bucket" do
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
    other_session = instance_double('BlobSession')
    allow(other_session).to receive(:serializable_hash).and_return(
      id: 'other-bucket',
      session_token: 'session_token',
      access_key_id: 'access_key_id',
      secret_access_key: 'secret_access_key',
    )
    allow(other_session).to receive(:read_attribute_for_serialization) do |attribute|
      if attribute.to_s == 'id'
        'other-bucket'
      else
        attribute.to_s
      end
    end
    allow(blob_session_class).to receive(:new) do |bucket, _|
      if bucket.to_s == 'test-bucket'
        test_session
      elsif bucket.to_s == 'other-bucket'
        other_session
      end
    end

    blob_sessions_hashes = [
      BlobSessionSerializer.new(test_session).as_json,
      BlobSessionSerializer.new(other_session).as_json
    ]

    expect(response_hash[:blob_sessions]).to match_array_of_hashes(blob_sessions_hashes)
  end
end
