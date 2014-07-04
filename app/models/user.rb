class User < ActiveRecord::Base
  has_secure_password validations: false

  def authenticate(password)
    if (result = super)
      update_attribute(:token, SecureRandom.base64)
      result
    end
  end

  def blob_bucket
    raise "Cannot determine User#blob_bucket without id" unless id
    "#{ENV['AWS_RESOURCE_PREFIX']}#{id}"
  end
end
