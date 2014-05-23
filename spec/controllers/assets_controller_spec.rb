require 'controller_spec_helper'
require 'app/controllers/assets_controller'

describe AssetsController do
  it "returns http success" do
    get :index
    response.should be_success
  end
end
