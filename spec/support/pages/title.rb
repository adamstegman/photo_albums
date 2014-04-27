module Pages
  class Title
    include Capybara::DSL

    def titled?(title)
      element.has_css?('h1', text: title)
    end

    private

    def element
      page.find('nav.top')
    end
  end
end
