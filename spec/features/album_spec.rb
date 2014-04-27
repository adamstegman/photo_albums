require 'feature_spec_helper'

feature 'A photo album', js: true do
  given!(:album) { double(:album, name: 'Inbox') }
  given!(:photo) { create :photo, :fixture }
  given!(:user) { create :user, password: 'abc' }

  # FIXME: create an album to use for this feature and assign the photo to it
  subject(:album_page) { Pages::Album.open(album.name) }

  context "when authenticated" do
    before do
      authentication_page.authenticate(user.email, 'abc')
    end

    scenario 'is active in the navigation menu' do
      subject
      expect(navigation_page).to have_active_item(album.name)
    end

    scenario 'displays its photos' do
      # FIXME: enhance by creating a photo in a different album that will not appear here
      expect(album_page).to have_photos([photo])
    end
  end

  context "when not authenticated" do
    before { pending "Without an album URL to visit directly, this is not testable" }

    scenario "is not available" do
      # visit Pages::Album.path_for(album.id)
      # expect(Pages::Album.new).not_to be_present
    end

    scenario "is displayed after logging in" do
      # visit Pages::Album.path_for(album.id)
      # Pages::Authentication.new.authenticate(user.email, 'abc')
      # expect(Pages::Album.new).to be_present
    end
  end
end
