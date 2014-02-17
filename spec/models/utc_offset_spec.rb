require 'spec_helper'
require 'addressable/template'
require 'multi_json'
require 'active_support/core_ext/date_time'
require 'app/models/utc_offset'

describe UtcOffset do
  describe '.utc_offset_hours' do
    let(:time) { Time.new(2013, 5, 14, 18, 55, 53) }

    subject { described_class.utc_offset_hours(time, gps) }

    context "when the service responds successfully" do
      let(:gps) { {latitude: 39.6591333, longitude: -0.2372} }

      before do
        stub_request(:get, "https://maps.googleapis.com/maps/api/timezone/json").
          with(query: {location: "39.6591333,-0.2372", timestamp: 1368575753, sensor: "true"}).
          to_return(status: 200, body: MultiJson.dump(response_hash))
      end

      context "when the UTC offset is found" do
        let(:response_hash) { {dstOffset: dst_offset, rawOffset: -28800, status: "OK", timeZoneId: "Europe/Madrid", timeZoneName: "Central European Standard Time"} }

        context "and there is no DST offset" do
          let(:dst_offset) { 0 }

          it "returns the raw offset in hours" do
            expect(subject).to eq(-8)
          end
        end

        context "and there is a DST offset" do
          let(:dst_offset) { 3600 }

          it "returns the raw offset and DST offset in hours" do
            expect(subject).to eq(-7)
          end
        end
      end

      context "when the UTC offset is not found" do
        let(:response_hash) { {status: "ZERO_RESULTS"} }

        it "raises UtcOffsetNotFoundError" do
          expect { subject }.to raise_error(described_class::UtcOffsetNotFoundError)
        end
      end
    end

    context "when the service response unsuccessfully" do
      let(:gps) { {} }

      before do
        stub_request(:get, "https://maps.googleapis.com/maps/api/timezone/json").
          with(query: {location: ",", timestamp: 1368575753, sensor: "true"}).
          to_return(status: 400, body: "Invalid request.")
      end

      it "raises UtcOffsetNotFoundError" do
        expect { subject }.to raise_error(described_class::UtcOffsetNotFoundError)
      end
    end
  end
end
