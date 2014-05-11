require 'feature_spec_helper'

feature 'A photo', js: true do
  given!(:photo) { create :photo, :real }
  given!(:user) { create :user, password: 'abc' }

  subject(:photo_page) { Pages::Photo.open(photo.id) }

  context "when authenticated" do
    before do
      Pages::Authentication.authenticate(user.email, 'abc')
    end

    scenario 'is displayed' do
      expect(photo_page).to be_photo(photo)
    end

    scenario 'displays its attributes' do
      expect(photo_page).to have_filename_of_photo(photo)
      expect(photo_page).to have_comment_of_photo(photo)
      expect(photo_page).to have_location_of_photo(photo)
      expect(photo_page).to have_taken_at_date_of_photo(photo)
    end

    scenario 'is labeled with its album' do
      subject
      # FIXME: photo.album.name
      expect(Pages::Title.new).to be_titled('Inbox')
    end
  end

  context "when not authenticated" do
    scenario "is displayed after logging in" do
      visit Pages::Photo.path_for(photo.id)
      expect(Pages::Photo.new).not_to be_present
      Pages::Authentication.authenticate(user.email, 'abc')
      visit Pages::Photo.path_for(photo.id)
      expect(Pages::Photo.new).to be_photo(photo)
    end
  end
end
