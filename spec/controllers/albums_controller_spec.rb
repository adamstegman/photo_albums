require 'controller_spec_helper'
require 'app/controllers/albums_controller'

describe AlbumsController do
  describe 'GET inbox' do
    let(:album) { Albums::Inbox.new }
    subject { get :inbox, format: :json }

    it_behaves_like "an authenticated controller action"

    context "when authenticated" do
      include_context "when the request is authorized for a user"

      it "returns the inbox attributes" do
        attributes = JSON.parse(subject.body)['album']
        expect(attributes['id']).to eq(album.id)
        expect(attributes['name']).to eq(album.name)
        expect(attributes['photo_ids']).to eq(album.photos.map(&:id))
      end
    end
  end
end
