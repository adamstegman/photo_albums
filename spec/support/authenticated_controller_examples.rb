shared_examples_for "an authenticated controller action" do
  context "when no authorization headers are sent" do
    before do
      request.headers['auth-email'] = nil
      request.headers['auth-token'] = nil
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when no user exists for the given authorization headers" do
    before do
      User.all.each(&:destroy)
      request.headers['auth-email'] = 'a@b'
      request.headers['auth-token'] = 'def'
    end

    it "returns 401 Unauthorized" do
      expect(subject.code).to eq("401")
    end
  end

  context "when correct authorization headers are sent" do
    include_context "when the request is authorized for a user"

    it "is successful" do
      expect(subject.code).to eq("200")
    end
  end
end

shared_context "when the request is authorized for a user" do
  let(:user) { create :user, :authenticated }

  before do
    request.headers['auth-email'] = user.email
    request.headers['auth-token'] = user.token
  end
end
