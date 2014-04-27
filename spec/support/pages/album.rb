module Pages
  class Album
    extend Capybara::DSL
    include Capybara::DSL

    def has_photos?(expected_photos)
      photos == expected_photos
    end

    def present?
      !!element
    rescue Capybara::ElementNotFound
      false
    end

    def photos
      photo_ids = photo_elements.map(&method(:photo_id_from_element))
      ::Photo.where(id: photo_ids)
    end

    def open_photo(photo_id)
      element.find("#photo-#{photo_id} a").click
    end

    def self.open(album_name)
      visit '/'
      navigation_page.navigate_to album_name
      new
    end

    private

    def photo_elements
      element.find('.album-thumbnails').all('li')
    end

    def photo_id_from_element(photo_element)
      if /\/(?<id>\d+)\z/ =~ photo_element.find('a')[:href]
        id
      end
    end

    def element
      page.find('.album-content')
    end
  end
end
