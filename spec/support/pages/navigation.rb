module Pages
  class Navigation
    include Capybara::DSL

    def has_active_item?(name)
      element.has_css? 'a.active', text: name
    end

    def navigate_to(name)
      unless has_active_item?(name)
        page.find('#show-nav-main').click
        element.find('a', text: name).click
        # TODO: wait for navigation to finish
        sleep 1
      end
    end

    private

    def element
      page.find('nav.main')
    end
  end
end
