module UtcOffset
  UtcOffsetNotFoundError = Class.new(StandardError)

  def self.utc_offset_hours(time, gps)
    url = time_zone_url(timestamp: time.to_i, sensor: true, location: "#{gps[:latitude]},#{gps[:longitude]}")
    response = Net::HTTP.get_response(url)
    if response.code.to_i == 200
      data = MultiJson.load(response.body)
      if data['rawOffset']
        (data['rawOffset'].to_i + data['dstOffset'].to_i) / 3600
      else
        raise UtcOffsetNotFoundError
      end
    else
      raise UtcOffsetNotFoundError
    end
  end

  TIME_ZONE_URL_TEMPLATE = Addressable::Template.new("https://maps.googleapis.com/maps/api/timezone/json{?location,timestamp,sensor}")

  def self.time_zone_url(params = {})
    TIME_ZONE_URL_TEMPLATE.expand(params)
  end
end
