require 'spec_helper'
require 'active_model/serializer'
require 'app/serializers/blob_session_serializer'

describe BlobSessionSerializer do
  subject(:session_hash) { described_class.new(blob_session).as_json }

  let(:blob_session) { instance_double('BlobSession') }
  before do
    allow(blob_session).to receive(:read_attribute_for_serialization).with(:id).and_return('bucket')
    allow(blob_session).to receive(:read_attribute_for_serialization).with(:access_key_id).and_return('access-key-id')
    allow(blob_session).to receive(:read_attribute_for_serialization).with(:secret_access_key).and_return('secret-access-key')
    allow(blob_session).to receive(:read_attribute_for_serialization).with(:session_token).and_return('token')
  end

  it "includes id" do
    expect(session_hash[:id]).to eq('bucket')
  end

  it "includes access key id" do
    expect(session_hash[:access_key_id]).to eq('access-key-id')
  end

  it "includes secret access key" do
    expect(session_hash[:secret_access_key]).to eq('secret-access-key')
  end

  it "includes session token" do
    expect(session_hash[:session_token]).to eq('token')
  end
end
