require 'spec_helper'

feature 'A photo album', js: true do
  given!(:album) { double(:album, name: 'Inbox') }
  given!(:photo) { create :photo, :fixture }

  before do
    # FIXME: create an album to use for this feature and assign the photo to it
    Pages::Album.open(album.name)
  end

  scenario 'is active in the navigation menu' do
    expect(navigation_page).to have_active_item(album.name)
  end

  scenario 'displays its photos' do
    # FIXME: enhance by creating a photo in a different album that will not appear here
    expect(album_page).to have_photos([photo])
  end
end
