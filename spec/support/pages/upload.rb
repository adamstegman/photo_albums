module Pages
  class Upload
    extend Capybara::DSL
    include Capybara::DSL

    def start_upload(filename)
      attach_file('photo', filename)
      upload_started = begin
                         Timeout.timeout(2) { until in_progress?(File.basename(filename)); end; true }
                       rescue Timeout::Error
                         false
                       end
      raise "Upload did not start" unless upload_started
    end

    def wait_for_upload(filename)
      sleep 0.1 while in_progress?(filename)
    end

    def in_progress?(filename)
      ongoing_uploads.include?(filename)
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
      page.find('.photo-upload')
    end

    def ongoing_uploads
      element.find('.upload-ongoing').all('li').map(&:text)
    rescue Capybara::ElementNotFound
      []
    end
  end
end
