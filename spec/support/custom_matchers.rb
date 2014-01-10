RSpec::Matchers.define :be_now do
  match do |actual|
    actual.to_i == Time.zone.now.to_i
  end

  failure_message_for_should do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} would be now (#{Time.zone.now})"
  end

  failure_message_for_should_not do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} would not be now (#{Time.zone.now})"
  end
end

RSpec::Matchers.define :be_at do |expected|
  match do |actual|
    actual.to_i == DateTime.parse(expected).to_i
  end

  failure_message_for_should do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} would be #{expected}"
  end

  failure_message_for_should_not do |actual|
    actual = 'nil' unless actual
    "expected that #{actual} would not be #{expected}"
  end
end
