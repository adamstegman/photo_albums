module Albums
  class Inbox
    NAME = 'Inbox'.freeze

    def initialize(user)
      @user = user
    end

    alias :read_attribute_for_serialization :send

    def id
      NAME.downcase
    end

    def name
      NAME
    end

    def photos
      Photo.for_user(@user)
    end
  end
end
