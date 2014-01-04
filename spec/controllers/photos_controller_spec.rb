require 'spec_helper'

describe PhotosController do
  describe 'GET index' do
    let(:photos) { create_list :real_photo, 2 }
    let(:photo_ids) { photos.map(&:id) }
    subject { get :index, ids: photo_ids, format: :json }

    before do
      create :photo # un-requested photo
    end

    it "returns the requested photo contents" do
      photos_attributes = JSON.parse(subject.body)['photos']

      expected_photos_attributes = photos.map { |photo| PhotoSerializer.new(photo).as_json[:photo].with_indifferent_access }
      expect(photos_attributes).to match_array(expected_photos_attributes)
    end

    it "does not return requested photos that do not exist" do
      photo_ids.push(99999)

      photos_attributes = JSON.parse(subject.body)['photos']

      expected_photos_attributes = photos.map { |photo| PhotoSerializer.new(photo).as_json[:photo].with_indifferent_access }
      expect(photos_attributes).to match_array(expected_photos_attributes)
    end
  end

  describe 'GET show' do
    let(:photo) { create :real_photo }

    subject { get :show, id: photo, format: :json }

    it "returns the photo attributes" do
      attributes = JSON.parse(subject.body)
      expected_photo_attributes = PhotoSerializer.new(photo).as_json.with_indifferent_access
      expect(attributes).to eq(expected_photo_attributes)
    end
  end
end
