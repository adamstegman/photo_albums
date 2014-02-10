require 'feature_spec_helper'

feature 'A photo', js: true do
  given!(:photo) { create :photo, :real }

  before do
    Pages::Photo.open(photo.id)
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
    # FIXME: photo.album.name
    expect(title_page).to be_titled('Inbox')
  end
end
