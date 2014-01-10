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

  it "includes taken_at" do
    expect(subject).to eq(photo.taken_at)
  end

  it "includes latitude" do
    expect(subject).to eq(photo.latitude)
  end

  it "includes longitude" do
    expect(subject).to eq(photo.longitude)
  end

  it "includes comment" do
    expect(subject).to eq(photo.comment)
  end

  it "includes content" do
    expect(subject).to eq(Base64.encode64(photo.content.read))
  end
end
