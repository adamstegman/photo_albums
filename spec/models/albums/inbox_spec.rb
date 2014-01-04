require 'spec_helper'

describe Albums::Inbox do
  let(:attribute) { example.example_group.description.sub('#', '') }
  subject { described_class.new.read_attribute_for_serialization(attribute) }

  describe '#id' do
    it "is present" do
      expect(subject).to be_present
    end
  end

  describe '#name' do
    it "is Inbox" do
      expect(subject).to eq('Inbox')
    end
  end

  describe '#photos' do
    it "is all photos" do
      create :photo
      expect(subject).to eq(Photo.all)
    end
  end
end
