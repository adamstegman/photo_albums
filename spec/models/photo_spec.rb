require 'active_record_spec_helper'
require 'app/models/photo'

describe Photo do
  describe '.for_user' do
    it "returns photos with the given user_id" do
      photo = create :photo
      other_photo = create :photo

      expect(described_class.for_user(photo.user)).to eq(described_class.where(user_id: photo.user_id))
    end
  end
end
