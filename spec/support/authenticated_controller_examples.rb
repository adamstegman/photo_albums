shared_examples_for "an authenticated controller action" do
  context "when no authorization headers are sent" do
    before do
      request.headers['Authorization'] = nil
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when an authenticated user exists for the given email and the wrong token is used" do
    before do
      request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials('wrong', user_email: user.email)
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when an unauthenticated user exists for the given email and an empty token is used" do
    before do
      request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials('', user_email: user.email)
      create :user
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end


  context "when an unauthenticated user exists for the given email and a nil token is used" do
    before do
      request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(nil, user_email: user.email)
      create :user
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when no user exists for the given authorization headers" do
    include_context "when the request is authorized for an authenticated user"

    before { User.destroy_all }

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when correct authorization headers are sent" do
    include_context "when the request is authorized for an authenticated user"

    it "is successful" do
      expect(subject).to be_success
    end
  end
end

shared_context "when the request is authorized for an authenticated user" do
  before do
    request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(user.token, user_email: user.email)
  end
end
