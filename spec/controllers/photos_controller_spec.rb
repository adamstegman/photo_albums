require 'controller_spec_helper'
require 'app/controllers/photos_controller'

describe PhotosController do
  let(:user) { create :user, :authenticated }

  describe 'POST create' do
    let(:attributes) { {filename: "filename", content_type: "some/type", blob_bucket: "some-bucket", blob_key: "some-key"} }
    subject { post :create, photo: attributes }

    it_behaves_like "an authenticated controller action"

    context "when authenticated" do
      include_context "when the request is authorized for an authenticated user"

      it "creates a photo for the current user with the given attributes" do
        expect { subject }.to change { Photo.for_user(user).count }.by(1)
        expect(subject.code).to eq('201')
        photo = Photo.last
        expect(photo.user).to eq(user)
        expect(photo.filename).to eq("filename")
        expect(photo.content_type).to eq("some/type")
        expect(photo.blob_bucket).to eq("some-bucket")
        expect(photo.blob_key).to eq("some-key")
      end

      it "schedules a worker to read more photo attributes" do
        # FIXME
      end

      context "with extra attributes" do
        let(:attributes) { {exif: "exif"} }

        it "ignores the extra attributes" do
          expect { subject }.to change { Photo.for_user(user).count }.by(1)
          expect(Photo.last.exif).to be_nil
        end
      end
    end
  end

  describe 'GET index' do
    subject { get :index, format: :json }

    it_behaves_like "an authenticated controller action"
  end

  describe 'GET show' do
    let!(:photo) { create :photo, user: user }
    subject { get :show, id: photo, format: :json }

    let(:serializer) { instance_double('PhotoSessionSerializer', as_json: {}) }
    before { class_double('PhotoSessionSerializer', new: serializer).as_stubbed_const }

    it_behaves_like "an authenticated controller action"
  end
end
