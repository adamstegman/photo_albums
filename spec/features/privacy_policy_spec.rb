require 'feature_spec_helper'

describe "Privacy Policy" do
  it "is displayed" do
    visit '/privacy'
    expected_content = File.read(File.expand_path('../../../app/views/static_pages/privacy.html', __FILE__))
    expect(Nokogiri::HTML(page.html).to_s.squeeze("\n")).to eq(Nokogiri::HTML(expected_content).to_s.squeeze("\n"))
  end
end
