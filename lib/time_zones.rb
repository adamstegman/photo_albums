module TimeZones
  DEFAULT_TIME_ZONE = ActiveSupport::TimeZone['America/Chicago']

  TimeZoneNotFoundError = Class.new(StandardError)

  def self.time_zone_for_location(gps)
    url = time_zone_url(timestamp: 1368575753, sensor: true, location: "#{gps[:latitude]},#{gps[:longitude]}")
    response = Net::HTTP.get_response(url)
    if response.code.to_i == 200
      data = MultiJson.load(response.body)
      if data['timeZoneId']
        ActiveSupport::TimeZone[data['timeZoneId']]
      else
        raise TimeZoneNotFoundError
      end
    else
      raise TimeZoneNotFoundError
    end
  end

  TIME_ZONE_URL_TEMPLATE = Addressable::Template.new("https://maps.googleapis.com/maps/api/timezone/json{?location,timestamp,sensor}")

  def self.time_zone_url(params = {})
    TIME_ZONE_URL_TEMPLATE.expand(params)
  end
end
