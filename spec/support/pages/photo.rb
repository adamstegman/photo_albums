module Pages
  class Photo
    extend Capybara::DSL
    include Capybara::DSL

    def photo?(photo)
      img = element.find('img')
      img[:src].include?(photo.to_base64)
    end

    def has_filename_of_photo?(photo)
      page_attributes.has_content?(photo.filename)
    end

    def has_comment_of_photo?(photo)
      page_attributes.has_content?(photo.comment)
    end

    def has_location_of_photo?(photo)
      coordinates = [photo.latitude, photo.longitude].map { |c| c.to_s[/^-?\d+\.?\d/] }
      page_attributes.find('a').text.split(',').map(&:strip).all? { |c| c.start_with?(coordinates.shift) }
    end

    def has_taken_at_date_of_photo?(photo)
      DateTime.parse(page_attributes.find('dd', text: /#{photo.taken_at.year}/).text).strftime('%D') == photo.taken_at.localtime.strftime('%D')
    end

    def self.open(photo_id)
      visit('/')
      # FIXME: photo.album.name
      navigation_page.navigate_to 'Inbox'
      album_page.find("#photo-#{photo_id} a").click
    end

    private

    def element
      @element ||= page.find('.photo-content')
    end

    def page_attributes
      @page_attributes ||= element.find('dl')
    end
  end
end

def photo_page
  @photo_page ||= Pages::Photo.new
end
