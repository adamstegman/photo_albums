module HashMatchingWithPrecision
  def sort_keys(expected_hash, actual_hash)
    removed_keys = expected_hash.keys - actual_hash.keys
    mismatched_keys = []
    added_keys = actual_hash.keys - expected_hash.keys
    expected_hash.each do |key, expected_value|
      next if removed_keys.include?(key)
      actual_value = value_with_precision(actual_hash[key])
      expected_value = value_with_precision(expected_value)
      mismatched_keys << key unless actual_value == expected_value
    end
    [removed_keys, mismatched_keys, added_keys]
  end

  def hash_matches?(expected_hash, actual_hash)
    sort_keys(expected_hash, actual_hash).all? { |keys| keys.empty? }
  end

  def failure_message(expected_hash, actual_hash)
    removed_keys, mismatched_keys, added_keys = sort_keys(expected_hash, actual_hash)
    message = "expected:\n#{expected_hash.inspect}\nto match"
    message << " with precision #{@precision}" if @precision
    message << ":\n#{actual_hash.inspect}"
    removed_keys.each do |key|
      message << "\n-#{key.inspect} => #{value_with_precision(expected_hash[key]).inspect}"
    end
    mismatched_keys.each do |key|
      message << "\n-#{key.inspect} => #{value_with_precision(expected_hash[key]).inspect}"
      message << "\n+#{key.inspect} => #{value_with_precision(actual_hash[key]).inspect}"
    end
    added_keys.each do |key|
      message << "\n+#{key.inspect} => #{value_with_precision(actual_hash[key]).inspect}"
    end
    message
  end

  def value_with_precision(value)
    if @precision && value.respond_to?(:round)
      value.round(@precision)
    else
      value
    end
  end
end

RSpec::Matchers.define :match_hash do |expected|
  include HashMatchingWithPrecision

  match do |actual|
    hash_matches?(expected, actual)
  end

  chain :with_precision do |precision|
    @precision = precision
  end

  failure_message_for_should do |actual|
    failure_message(expected, actual)
  end
end

RSpec::Matchers.define :match_array_of_hashes do |expected|
  include HashMatchingWithPrecision

  def closest_matching_hashes(expected_hashes, actual_hashes)
    leftover_actual_hashes = actual_hashes.dup
    expected_hashes.reduce({}) { |hashes, expected_hash|
      closest_actual_hash = leftover_actual_hashes.min { |a, b|
        hash_match_score(expected_hash, a) <=> hash_match_score(expected_hash, b)
      }
      hashes.merge(expected_hash => leftover_actual_hashes.delete(closest_actual_hash))
    }
  end

  def hash_match_score(expected, actual)
    sort_keys(expected, actual).reduce(0) { |sum, keys| sum + keys.size }
  end

  match do |actual|
    closest_matching_hashes(expected, actual).all? { |expected_hash, actual_hash|
      hash_matches?(expected_hash, actual_hash)
    }
  end

  chain :with_precision do |precision|
    @precision = precision
  end

  failure_message_for_should do |actual|
    closest_matching_hashes(expected, actual).map { |expected_hash, actual_hash|
      failure_message(expected_hash, actual_hash) unless hash_matches?(expected_hash, actual_hash)
    }.compact.join("\n----------\n")
  end
end
