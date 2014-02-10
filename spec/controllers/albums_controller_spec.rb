require 'controller_spec_helper'
require 'app/controllers/albums_controller'

describe AlbumsController do
  describe 'GET inbox' do
    let(:album) { Albums::Inbox.new }
    let(:make_request) { get :inbox, format: :json }

    it "returns the inbox attributes" do
      attributes = JSON.parse(make_request.body)['album']
      expect(attributes['id']).to eq(album.id)
      expect(attributes['name']).to eq(album.name)
      expect(attributes['photo_ids']).to eq(album.photos.map(&:id))
    end
  end
end
