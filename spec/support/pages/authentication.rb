module Pages
  class Authentication
    include Capybara::DSL

    def authenticate(username, password)
      visit '/#/login'
      fill_in "Username", with: username
      fill_in "Password", with: password
      click_on "Log in"
      # TODO: wait for log in to finish
      sleep 1
    end
  end
end

def authentication_page
  @authentication_page ||= Pages::Authentication.new
end
