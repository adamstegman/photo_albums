require 'active_record_spec_helper'
require 'app/serializers/album_serializer'

describe AlbumSerializer do
  let(:user) { create :user }
  let!(:photo) { create :photo, user: user }
  let(:album) { Albums::Inbox.new(user) }
  let(:album_hash) { described_class.new(album).as_json[:album] }

  it "includes id" do
    expect(album_hash[:id]).to eq(album.id)
  end

  it "includes name" do
    expect(album_hash[:name]).to eq(album.name)
  end

  it "includes photo_ids" do
    expect(album_hash[:photo_ids]).to eq(album.photos.map(&:id))
  end
end
