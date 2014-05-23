require 'active_record_spec_helper'
require 'app/serializers/user_serializer'

describe UserSerializer do
  let(:user) { create :user, :authenticated }
  let(:user_hash) { described_class.new(user).as_json }

  it "includes user_email" do
    expect(user_hash[:user_email]).to eq(user.email)
  end

  it "includes user_token" do
    expect(user_hash[:user_token]).to eq(user.token)
  end
end
