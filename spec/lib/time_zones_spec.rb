require 'spec_helper'
require 'multi_json'

require 'active_support/core_ext/date_time'
require 'active_support/duration'
require 'addressable/template'
require 'time_zones'

describe TimeZones do
  describe '.time_zone_for_location' do
    subject { described_class.time_zone_for_location(gps) }

    context "when the service responds successfully" do
      let(:gps) { {latitude: 39.6591333, longitude: -0.2372} }

      before do
        stub_request(:get, "https://maps.googleapis.com/maps/api/timezone/json").
          with(query: {location: "39.6591333,-0.2372", timestamp: 1368575753, sensor: "true"}).
          to_return(status: 200, body: MultiJson.dump(response_hash))
      end

      context "when the time zone is found" do
        let(:response_hash) { {dstOffset: 0, rawOffset: -28800, status: "OK", timeZoneId: "Europe/Madrid", timeZoneName: "Central European Standard Time"} }

        it "returns the time zone from the response" do
          expect(subject).to eq(ActiveSupport::TimeZone['Europe/Madrid'])
        end
      end

      context "when the time zone is not found" do
        let(:response_hash) { {status: "ZERO_RESULTS"} }

        it "raises TimeZoneNotFoundError" do
          expect { subject }.to raise_error(described_class::TimeZoneNotFoundError)
        end
      end
    end

    context "when the service responds with an error" do
      let(:gps) { {} }

      before do
        stub_request(:get, "https://maps.googleapis.com/maps/api/timezone/json").
          with(query: hash_including(location: ",", sensor: "true")).
          to_return(status: 400, body: "Invalid request.")
      end

      it "raises TimeZoneNotFoundError" do
        expect { subject }.to raise_error(described_class::TimeZoneNotFoundError)
      end
    end
  end
end
