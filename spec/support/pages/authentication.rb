module Pages
  class Authentication
    extend Capybara::DSL
    include Capybara::DSL

    def self.authenticate(username, password)
      visit '/#/login'
      new.authenticate(username, password)
    end

    def authenticate(username, password)
      fill_in "Username", with: username
      fill_in "Password", with: password
      click_on "Log in"
      # TODO: wait for log in to finish
      sleep 1
    end
  end
end
