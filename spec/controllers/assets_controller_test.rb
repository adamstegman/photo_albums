require 'spec_helper'

describe AssetsController do
  it "returns http success" do
    get :index
    response.should be_success
  end
end
