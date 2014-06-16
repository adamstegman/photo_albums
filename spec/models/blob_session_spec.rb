require 'active_record_spec_helper'
require 'app/models/blob_session'

describe BlobSession do
  subject(:session) { described_class.new('bucket', user) }
  let(:user) { build(:user, access_key_id: 'abc', secret_access_key: 'def') }

  let(:sts_session) {
    instance_double(
      'AWS::STS::Session',
      credentials: {
        session_token: 'token',
        secret_access_key: 'some-secret',
        access_key_id: 'some-access-key-id',
      }
    )
  }
  let(:sts) { instance_double('AWS::STS', new_session: sts_session) }
  let!(:sts_class) { class_double('AWS::STS', new: sts).as_stubbed_const }

  describe 'id' do
    it "is the blob bucket" do
      expect(session.read_attribute_for_serialization(:id)).to eq('bucket')
      expect(session.serializable_hash[:id]).to eq('bucket')
    end
  end

  describe 'access_key_id' do
    it "is the blob bucket" do
      expect(session.read_attribute_for_serialization(:access_key_id)).to eq('some-access-key-id')
      expect(session.serializable_hash[:access_key_id]).to eq('some-access-key-id')
    end
  end

  describe 'secret_access_key' do
    it "is the blob bucket" do
      expect(session.read_attribute_for_serialization(:secret_access_key)).to eq('some-secret')
      expect(session.serializable_hash[:secret_access_key]).to eq('some-secret')
    end
  end

  describe 'session_token' do
    it "is the blob bucket" do
      expect(session.read_attribute_for_serialization(:session_token)).to eq('token')
      expect(session.serializable_hash[:session_token]).to eq('token')
    end
  end

  it "creates a single one-hour session with the user's credentials" do
    expect(sts_class).to receive(:new).with(access_key_id: 'abc', secret_access_key: 'def')
    expect(sts).to receive(:new_session).with(duration: 3600).once

    # ensure the session is cached by calling multiple session-related methods and asserting it is only created once
    session.access_key_id
    session.secret_access_key
    session.session_token
  end
end
