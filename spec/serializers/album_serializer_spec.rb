require 'spec_helper'

describe AlbumSerializer do
  let(:album) { Albums::Inbox.new }

  let(:attribute) { example.description.sub(/^includes /, '').to_sym }
  subject { described_class.new(album).as_json[:album][attribute] }

  it "includes id" do
    expect(subject).to eq(album.id)
  end

  it "includes name" do
    expect(subject).to eq(album.name)
  end

  it "includes photo_ids" do
    expect(subject).to eq(album.photos.map(&:id))
  end
end
