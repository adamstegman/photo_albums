require 'feature_spec_helper'

feature 'The Inbox album', js: true do
  given!(:photo) { create :photo, :fixture }
  given!(:user) { create :user, password: 'abc' }

  subject(:album_page) { Pages::Album.open('Inbox') }

  context "when authenticated" do
    before do
      authentication_page.authenticate(user.email, 'abc')
    end

    scenario 'is shown at the root path' do
      visit '/'
      expect(navigation_page).to have_active_item('Inbox')
    end

    scenario 'has photos not in another album' do
      # TODO: enhance by creating a photo in a different album that will not appear here
      expect(album_page).to have_photos([photo])
    end
  end

  context "when not authenticated" do
    scenario "is not available" do
      visit '/'
      expect(Pages::Album.new).not_to be_present
    end

    scenario "is displayed after logging in" do
      visit '/'
      Pages::Authentication.new.authenticate(user.email, 'abc')
      expect(Pages::Album.new).to be_present
    end
  end
end
