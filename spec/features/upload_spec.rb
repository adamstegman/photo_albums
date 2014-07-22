require 'feature_spec_helper'

feature 'Uploading photos', js: true do
  given!(:user) { create :real_user, password: 'abc' }
  given!(:album) { double(:album, name: 'Inbox', id: 'inbox') }

  subject(:upload_page) { Pages::Upload.open(album.name) }

  context "when authenticated" do
    before do
      Pages::Authentication.authenticate(user.email, 'abc')
    end

    scenario 'creates a photo in the album' do
      upload_page.upload(fixture_file_path('IMG_2598.jpg'))

      # wait for redirect to album page
      album_page = Pages::Album.new
      Timeout.timeout(10) do
        sleep 0.1 until album_page.present?
      end

      # DB state is not ready until we wait for a split-second. Refresh is necessary to pick up the new photo.
      Timeout.timeout(1) do
        sleep 0.1 until Photo.for_user(user).count > 0
      end
      visit current_path

      expect(album_page.photos.size).to eq(1)
    end

    scenario 'adds attributes to the photo' do
      pending "Not implemented."
    end
  end

  context "when not authenticated" do
    scenario "is displayed after logging in" do
      visit Pages::Upload.path_for(album.id)
      expect(Pages::Upload.new).not_to be_present
      Pages::Authentication.authenticate(user.email, 'abc')
      visit Pages::Upload.path_for(album.id)
      expect(Pages::Upload.new).to be_present
    end
  end
end
