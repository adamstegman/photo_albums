require 'active_record_spec_helper'
require 'app/serializers/user_serializer'

describe UserSerializer do
  let(:user) { create :user, :authenticated }
  let(:user_hash) { described_class.new(user).as_json }

  it "includes auth_email" do
    expect(user_hash[:auth_email]).to eq(user.email)
  end

  it "includes auth_token" do
    expect(user_hash[:auth_token]).to eq(user.token)
  end
end
