require 'active_record_spec_helper'
require 'app/models/albums/inbox'

describe Albums::Inbox do
  let(:inbox) { described_class.new }

  describe '#id' do
    subject { inbox.read_attribute_for_serialization(:id) }

    it "is present" do
      expect(subject).to be_present
    end
  end

  describe '#name' do
    subject { inbox.read_attribute_for_serialization(:name) }

    it "is Inbox" do
      expect(subject).to eq('Inbox')
    end
  end

  describe '#photos' do
    subject { inbox.read_attribute_for_serialization(:photos) }

    it "is all photos" do
      create :photo
      expect(subject).to eq(Photo.all)
    end
  end
end
