require 'controller_spec_helper'
require 'app/controllers/users_controller'

describe UsersController do
  subject(:request) { post :sign_in, user: {email: email, password: user.password}, format: :json }
  let(:email) { user.email }

  let(:user) { create :user, :authenticated }
  before { allow(User).to receive(:where).with(email: user.email).and_return(double(:relation, first: user)) }

  describe "POST sign_in" do
    it "returns the authenticated user" do
      expect(user).to receive(:authenticate).with(user.password).and_return(user)

      expect(request.code).to eq("201")

      expected_attributes = JSON.parse(UserSerializer.new(user).to_json).with_indifferent_access
      expect(JSON.parse(request.body)).to eq(expected_attributes)
    end

    context "when the email is improperly cased" do
      let(:email) { user.email.upcase }

      it "returns the authenticated user" do
        expect(user).to receive(:authenticate).with(user.password).and_return(user)

        expect(request.code).to eq("201")

        expected_attributes = JSON.parse(UserSerializer.new(user).to_json).with_indifferent_access
        expect(JSON.parse(request.body)).to eq(expected_attributes)
      end
    end

    context "when the password is incorrect" do
      before { expect(user).to receive(:authenticate).with(user.password).and_return(false) }

      it "returns Unauthorized" do
        expect(request.code).to eq("401")
      end
    end

    context "when the user cannot be found" do
      before { allow(User).to receive(:where).with(email: user.email).and_return(double(:relation, first: nil)) }

      it "returns Unauthorized" do
        expect(request.code).to eq("401")
      end
    end
  end
end
