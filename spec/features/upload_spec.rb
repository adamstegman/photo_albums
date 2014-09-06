require 'feature_spec_helper'

feature 'Uploading photos', js: true do
  given!(:user) { create :real_user, password: 'abc' }

  subject(:upload_page) { Pages::Upload.open }

  context "when authenticated" do
    before do
      Pages::Authentication.authenticate(user.email, 'abc')
    end

    scenario 'creates a photo in the album' do
      upload_page.start_upload(fixture_file_path('IMG_2598.jpg'))
      upload_page.wait_for_upload('IMG_2598.jpg')

      album_page = Pages::Album.open('Inbox')
      expect(album_page.photos.size).to eq(1)
    end

    scenario 'adds attributes to the photo' do
      pending "Not implemented."
    end
  end

  context "when not authenticated" do
    scenario "is displayed after logging in" do
      visit Pages::Upload.path
      expect(Pages::Upload.new).not_to be_present
      Pages::Authentication.authenticate(user.email, 'abc')
      visit Pages::Upload.path
      expect(Pages::Upload.new).to be_present
    end
  end
end
