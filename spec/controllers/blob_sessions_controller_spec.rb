require 'controller_spec_helper'
require 'app/controllers/blob_sessions_controller'

describe BlobSessionsController do
  let(:user) { create :user, :authenticated }

  describe 'GET show' do
    subject { get :show, {}, format: :json }

    let!(:blob_session_class) { class_double('BlobSession', new: blob_session).as_stubbed_const }
    let(:blob_session) { instance_double('BlobSession', read_attribute_for_serialization: 'value') }

    it_behaves_like "an authenticated controller action"

    context "when authenticated" do
      include_context "when the request is authorized for an authenticated user"

      it "returns a new blob session for the user" do
        expect(blob_session_class).to receive(:new).with(user.blob_bucket, user)

        expect(subject.code).to eq('200')

        expected_attributes = JSON.parse(BlobSessionSerializer.new(blob_session).to_json).with_indifferent_access
        expect(JSON.parse(response.body)).to eq('blob_session' => expected_attributes)
      end
    end
  end
end
