require 'feature_spec_helper'

feature 'The Inbox album', js: true do
  given!(:photo) { create :photo, :fixture }

  before do
    Pages::Album.open('Inbox')
  end

  scenario 'is shown at the root path' do
    visit '/'
    expect(navigation_page).to have_active_item('Inbox')
  end

  scenario 'has photos not in another album' do
    # FIXME: enhance by creating a photo in a different album that will not appear here
    expect(album_page).to have_photos([photo])
  end
end
