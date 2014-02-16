require 'spec_helper'
require 'logger'
require 'active_support/core_ext/date_time'
require 'app/models/photo_metadata'

describe PhotoMetadata do
  let!(:exifr_jpeg) { class_double('EXIFR::JPEG').as_stubbed_const }
  let(:content) { double(:content).as_null_object }

  subject { described_class.new(content, logger: Logger.new('/dev/null')) }

  shared_examples_for "all EXIF-derived attributes are nil" do
    describe '#latitude' do
      it "is nil" do
        expect(subject.latitude).to be_nil
      end
    end

    describe '#longitude' do
      it "is nil" do
        expect(subject.longitude).to be_nil
      end
    end

    describe '#comment' do
      it "is nil" do
        expect(subject.comment).to be_nil
      end
    end

    describe '#taken_at' do
      it "is nil" do
        expect(subject.taken_at).to be_nil
      end
    end

    describe '#exif_hash' do
      it "is nil" do
        expect(subject.exif_hash).to be_nil
      end
    end
  end

  describe '#content_type' do
    context "when the content has a file" do
      before do
        allow(content).to receive(:file).and_return(double(:file, content_type: 'image/jpeg'))
      end

      it "is the file's content type" do
        expect(subject.content_type).to eq('image/jpeg')
      end
    end

    context "when the content has no file" do
      before do
        allow(content).to receive(:file).and_return(nil)
      end

      it "is nil" do
        expect(subject.content_type).to be_nil
      end
    end
  end

  describe '#filename' do
    context "when the content has a filename" do
      before do
        allow(content).to receive(:filename).and_return('filename')
      end

      it "is the filename" do
        expect(subject.filename).to eq('filename')
      end
    end

    context "when the content has no filename" do
      before do
        allow(content).to receive(:filename).and_return(nil)
      end

      it "is nil" do
        expect(subject.filename).to be_nil
      end
    end
  end

  context "when the content is a JPEG" do
    before do
      allow(content).to receive(:file).and_return(double(:file, content_type: 'image/jpeg'))
    end

    context "when the photo has EXIF data" do
      let(:exif) { double('EXIFR::JPEG') }

      before do
        allow(exifr_jpeg).to receive(:new).and_return(exif)
      end

      context "when the EXIF data has a GPS location" do
        before do
          allow(exif).to receive(:gps).and_return(latitude: 30.333333, longitude: -94.066667)
        end

        describe '#latitude' do
          it "is the GPS latitude" do
            expect(subject.latitude).to be_within(0.00001).of(30.33333)
          end
        end

        describe '#longitude' do
          it "is the GPS longitude" do
            expect(subject.longitude).to be_within(0.00001).of(-94.066667)
          end
        end
      end

      context "when the EXIF data has no GPS location" do
        before do
          allow(exif).to receive(:gps).and_return(nil)
        end

        describe '#latitude' do
          it "is nil" do
            expect(subject.latitude).to be_nil
          end
        end

        describe '#longitude' do
          it "is nil" do
            expect(subject.longitude).to be_nil
          end
        end
      end

      describe '#comment' do
        context "when there is an exif comment" do
          before do
            allow(exif).to receive(:comment).and_return("comment")
          end

          it "is the exif comment" do
            expect(subject.comment).to eq("comment")
          end
        end

        context "when the exif comment is nil" do
          before do
            allow(exif).to receive(:comment).and_return(nil)
          end

          it "is nil" do
            expect(subject.comment).to be_nil
          end
        end
      end

      describe '#taken_at' do
        context "when there is an EXIF GPS time stamp" do
          before do
            allow(exif).to receive(:gps_date_stamp).and_return("2013:05:14")
            allow(exif).to receive(:gps_time_stamp).and_return([Rational(23/1), Rational(55/1), Rational(53/1)])
          end

          it "is set to the GPS UTC time stamp" do
            expect(subject.taken_at).to be_at("2013-05-14T23:55:53Z")
          end
        end

        context "when there is no EXIF GPS time stamp" do
          before do
            allow(exif).to receive(:gps_date_stamp).and_return(nil)
            allow(exif).to receive(:gps_time_stamp).and_return(nil)
          end

          context "when there is an EXIF original date time" do
            let!(:utc_offset_class) { class_double("UtcOffset").as_stubbed_const }
            let(:date_time_original) { Time.new(2013, 5, 14, 18, 55, 53) }

            before do
              allow(exif).to receive(:date_time_original).and_return(date_time_original)
              stub_const("UtcOffset::DEFAULT_UTC_OFFSET", -6)
            end

            context "when there is a GPS location" do
              before do
                allow(exif).to receive(:gps).and_return(:gps)
              end

              context "and the GPS location is valid" do
                before do
                  allow(utc_offset_class).to receive(:utc_offset_hours).with(date_time_original, :gps).and_return(2)
                end

                it "is set to the original date time in the time zone of the location" do
                  expect(subject.taken_at).to be_at("2013-05-14T16:55:53Z")
                end
              end

              context "and the GPS location is not valid" do
                before do
                  utc_offset_not_found = Class.new(StandardError)
                  stub_const("UtcOffset::UtcOffsetNotFoundError", utc_offset_not_found)
                  allow(utc_offset_class).to receive(:utc_offset_hours).with(date_time_original, :gps).and_raise(utc_offset_not_found)
                end

                it "is set to the original date time in Central time" do
                  expect(subject.taken_at).to be_at("2013-05-14T23:55:53Z")
                end
              end
            end

            context "when there is no GPS location" do
              before do
                allow(exif).to receive(:gps).and_return(nil)
              end

              it "is set to the original date time in Central time" do
                expect(subject.taken_at).to be_at("2013-05-14T23:55:53Z")
              end
            end
          end

          context "when there is no EXIF original date time" do
            before do
              allow(exif).to receive(:date_time_original).and_return(nil)
            end

            it "is nil" do
              expect(subject.taken_at).to be_nil
            end
          end
        end
      end

      describe '#exif_hash' do
        before do
          allow(exif).to receive(:exif).and_return(double(:exif_exif, to_hash: {exif: 'data'}))
        end

        it "is the exif hash" do
          expect(subject.exif_hash).to eq(exif: 'data')
        end
      end
    end

    context "when the photo has no EXIF data" do
      let(:exifr_jpeg) { class_double('EXIFR::JPEG').as_stubbed_const }

      before do
        allow(exifr_jpeg).to receive(:new).and_raise(ArgumentError.new("string contains null byte"))
      end

      describe '#latitude' do
        it "is nil" do
          expect(subject.latitude).to be_nil
        end
      end

      describe '#longitude' do
        it "is nil" do
          expect(subject.longitude).to be_nil
        end
      end

      describe '#comment' do
        it "is nil" do
          expect(subject.comment).to be_nil
        end
      end

      describe '#taken_at' do
        it "is nil" do
          expect(subject.taken_at).to be_nil
        end
      end

      describe '#exif_hash' do
        it "is nil" do
          expect(subject.exif_hash).to be_nil
        end
      end
    end
  end

  context "when there is no content" do
    let(:content) { nil }

    it_behaves_like "all EXIF-derived attributes are nil"

    describe '#content_type' do
      it "is nil" do
        expect(subject.content_type).to be_nil
      end
    end

    describe '#filename' do
      it "is nil" do
        expect(subject.filename).to be_nil
      end
    end
  end

  context "when the content is not well-formed" do
    let(:exifr_jpeg) { class_double('EXIFR::JPEG').as_stubbed_const }

    before do
      malformed_jpeg = Class.new(StandardError)
      stub_const('EXIFR::MalformedJPEG', malformed_jpeg)
      allow(exifr_jpeg).to receive(:new).and_raise(EXIFR::MalformedJPEG)
    end

    it_behaves_like "all EXIF-derived attributes are nil"
  end
end
