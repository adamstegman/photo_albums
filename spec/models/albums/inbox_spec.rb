require 'spec_helper'

describe Albums::Inbox do
  let(:attribute) { example.example_group.description }
  subject { described_class.new.read_attribute_for_serialization(attribute) }

  describe 'id' do
    it "is present" do
      expect(subject).to be_present
    end
  end

  describe 'name' do
    it "is Inbox" do
      expect(subject).to eq('Inbox')
    end
  end
end
