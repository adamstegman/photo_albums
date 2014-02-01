module Pages
  class Navigation
    include Capybara::DSL

    def has_active_item?(name)
      element.has_css? 'a.active', text: name
    end

    def navigate_to(name)
      element.find('a', text: name).click unless has_active_item?(name)
    end

    private

    def element
      @element ||= page.find('nav.main')
    end
  end
end

def navigation_page
  @navigation_page ||= Pages::Navigation.new
end
