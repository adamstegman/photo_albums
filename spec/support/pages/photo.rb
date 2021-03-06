module Pages
  class Photo
    extend Capybara::DSL
    include Capybara::DSL

    def photo?(photo)
      raise ArgumentError unless photo.id
      photo_id_from_element(element) == photo.id
    end

    def present?
      !!element
    rescue Capybara::ElementNotFound
      false
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
      # FIXME: photo.album.name
      Pages::Album.open('Inbox').open_photo(photo_id)
      new
    end

    def self.path_for(photo_id)
      "/#/photos/#{photo_id}"
    end

    private

    def element
      page.find('.photo-content')
    end

    def page_attributes
      @page_attributes ||= element.find('dl')
    end

    def photo_id_from_element(photo_element)
      if /\Aphoto-(?<id>\d+)\z/ =~ photo_element[:id]
        id.to_i
      end
    end
  end
end
