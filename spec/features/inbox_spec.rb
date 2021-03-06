require 'feature_spec_helper'

feature 'The Inbox album', js: true do
  given!(:user) { create :real_user, password: 'abc' }
  given!(:photo) { create :real_photo, user: user }

  subject(:album_page) { Pages::Album.open('Inbox') }

  context "when authenticated" do
    before do
      Pages::Authentication.authenticate(user.email, 'abc')
    end

    scenario 'is shown at the root path' do
      visit '/'
      expect(Pages::Navigation.new).to have_active_item('Inbox')
    end

    scenario 'has photos not in another album' do
      # TODO: enhance by creating a photo in a different album that will not appear here
      expect(album_page).to have_photos([photo])
    end
  end

  context "when not authenticated" do
    scenario "is displayed after logging in" do
      visit '/'
      expect(Pages::Album.new).not_to be_present
      Pages::Authentication.authenticate(user.email, 'abc')
      visit '/'
      expect(Pages::Album.new).to be_present
    end
  end
end
