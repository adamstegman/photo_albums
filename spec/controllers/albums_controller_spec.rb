require 'spec_helper'

describe AlbumsController do
  describe 'GET inbox' do
    let(:make_request) { get :inbox, format: :json }

    it "includes the Inbox name" do
      attributes = JSON.parse(make_request.body)['album']
      expect(attributes['name']).to eq('Inbox')
    end
  end
end
