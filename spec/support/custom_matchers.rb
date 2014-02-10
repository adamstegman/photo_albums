RSpec::Matchers.define :be_now do
  match do |actual|
    actual.to_i == Time.zone.now.to_i
  end

  failure_message_for_should do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} (#{actual.to_i}) would be now (#{Time.zone.now}, #{Time.zone.now.to_i})"
  end

  failure_message_for_should_not do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} (#{actual.to_i}) would not be now (#{Time.zone.now}, #{Time.zone.now.to_i})"
  end
end

RSpec::Matchers.define :be_at do |expected|
  match do |actual|
    actual.to_i == Time.parse(expected).to_i
  end

  failure_message_for_should do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} (#{actual.to_i}) would be #{expected} (#{Time.parse(expected).to_i})"
  end

  failure_message_for_should_not do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} (#{actual.to_i}) would not be #{expected} (#{Time.parse(expected).to_i})"
  end
end
