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

    def self.open
      visit '/'
      click_link 'Upload'
      new
    end

    def self.path
      "/#/upload"
    end

    private

    def element
      page.find('.album-upload')
    end
  end
end
