class User < ActiveRecord::Base
  has_secure_password validations: false

  def authenticate(password)
    if (result = super)
      update_attribute(:token, SecureRandom.base64)
      result
    end
  end
end
