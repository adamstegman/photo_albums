require 'feature_spec_helper'

describe "Privacy Policy" do
  it "is displayed" do
    privacy_policy_path = File.expand_path('../../../app/views/static_pages/privacy.html', __FILE__)
    pending "Cannot test this without a privacy policy" unless File.exists?(privacy_policy_path)

    visit '/privacy'
    expected_content = File.read(privacy_policy_path)
    expect(Nokogiri::HTML(page.html).to_s.squeeze("\n")).to eq(Nokogiri::HTML(expected_content).to_s.squeeze("\n"))
  end
end
