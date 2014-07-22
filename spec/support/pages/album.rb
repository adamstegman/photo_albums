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
      Pages::Navigation.new.navigate_to album_name
      new
    end

    def self.path_for(album_id)
      "/#/albums/#{album_id}"
    end

    private

    def photo_elements
      # using the poor man's timeout instead of Timeout::timeout
      # Timeout.timeout fails when using Capybara finders, presumably because Capybara is using Timeout internally
      elements = []
      start = Time.now.to_i
      until elements.any? || (Time.now.to_i - start) == Capybara.default_wait_time
        sleep 0.1
        elements = element.find('.album-thumbnails').all('li')
      end
      elements
    end

    def photo_id_from_element(photo_element)
      if /\Aphoto-(?<id>\d+)\z/ =~ photo_element[:id]
        id
      end
    end

    def element
      page.find('.album-content')
    end
  end
end
