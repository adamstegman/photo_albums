module Pages
  class Upload
    extend Capybara::DSL
    include Capybara::DSL

    def upload(filename)
      attach_file('photo', filename)
      click_link 'Upload'
    end

    def present?
      !!element
    rescue Capybara::ElementNotFound
      false
    end

    def self.open(album_name)
      visit '/'
      Pages::Navigation.new.navigate_to album_name
      click_link 'Upload'
      new
    end

    def self.path_for(album_id)
      "/#/albums/#{album_id}/upload"
    end

    private

    def element
      page.find('.album-upload')
    end
  end
end
