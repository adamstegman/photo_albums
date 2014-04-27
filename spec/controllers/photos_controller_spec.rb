require 'controller_spec_helper'
require 'app/controllers/photos_controller'

describe PhotosController do
  describe 'GET index' do
    let(:photos) { create_list :real_photo, 2 }
    let(:photo_ids) { photos.map(&:id) }
    subject { get :index, ids: photo_ids, format: :json }

    before do
      create :photo # un-requested photo
    end

    it_behaves_like "an authenticated controller action"

    context "when authenticated" do
      include_context "when the request is authorized for a user"

      it "returns the requested photo contents" do
        photos_attributes = JSON.parse(subject.body)['photos']

        expected_photos_attributes = photos.map { |photo| JSON.parse(PhotoSerializer.new(photo).to_json).with_indifferent_access[:photo] }
        expect(photos_attributes).to match_array_of_hashes(expected_photos_attributes).with_precision(5)
      end

      it "does not return requested photos that do not exist" do
        photo_ids.push(99999)

        photos_attributes = JSON.parse(subject.body)['photos']

        expected_photos_attributes = photos.map { |photo| JSON.parse(PhotoSerializer.new(photo).to_json).with_indifferent_access[:photo] }
        expect(photos_attributes).to match_array_of_hashes(expected_photos_attributes).with_precision(5)
      end
    end
  end

  describe 'GET show' do
    let(:photo) { create :real_photo }

    subject { get :show, id: photo, format: :json }

    it_behaves_like "an authenticated controller action"

    context "when authenticated" do
      include_context "when the request is authorized for a user"

      it "returns the photo attributes" do
        attributes = JSON.parse(subject.body)['photo']
        expected_photo_attributes = JSON.parse(PhotoSerializer.new(photo).to_json).with_indifferent_access[:photo]
        expect(attributes).to match_hash(expected_photo_attributes).with_precision(5)
      end
    end
  end
end
