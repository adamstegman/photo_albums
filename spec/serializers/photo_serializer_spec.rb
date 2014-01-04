require 'spec_helper'

describe PhotoSerializer do
  let(:photo) { create :photo, :real }

  let(:attribute) { example.description.sub(/^includes /, '').to_sym }
  subject { described_class.new(photo).as_json[:photo][attribute] }

  it "includes id" do
    expect(subject).to eq(photo.id)
  end

  it "includes filename" do
    expect(subject).to eq(photo.filename)
  end

  it "includes content_type" do
    expect(subject).to eq(photo.content_type)
  end

  it "includes width" do
    expect(subject).to eq(photo.width)
  end

  it "includes height" do
    expect(subject).to eq(photo.height)
  end

  it "includes content" do
    expect(subject).to eq(Base64.encode64(photo.content.read))
  end
end
