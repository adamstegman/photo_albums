require 'active_record_spec_helper'
require 'app/models/user'

describe User do
  it "authenticates the user with a password" do
    user = create :user, email: 'a@b', password: 'abc'
    expect(User.where(email: 'a@b').first.authenticate('abc')).to eq(user)
  end

  it "generates a token on authentication" do
    user = create :user, email: 'a@b', password: 'abc'
    expect(user.token).to be_nil

    User.where(email: 'a@b').first.authenticate('abc')

    token = user.reload.token
    expect(token).not_to be_nil
  end

  it "hashes the password in the database" do
    user = create :user, password: "abc"
    expect("abc").not_to eq(user.password_digest)
  end

  it "has a blob bucket where its photos should go" do
    stub_const('ENV', 'AWS_RESOURCE_PREFIX' => 'bucket-')
    user = create :user
    expect(user.blob_bucket).to eq("bucket-#{user.id}")
  end

  it "does not have a blob bucket if it is not persisted" do
    expect { build(:user).blob_bucket }.to raise_error
  end
end
