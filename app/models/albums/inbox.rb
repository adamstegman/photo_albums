module Albums
  class Inbox
    NAME = 'Inbox'.freeze

    alias :read_attribute_for_serialization :send

    def id
      NAME
    end

    def name
      NAME
    end

    def photos
      Photo.all
    end
  end
end
