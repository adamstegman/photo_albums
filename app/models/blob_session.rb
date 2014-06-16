class BlobSession
  def initialize(blob_bucket, user)
    @blob_bucket = blob_bucket
    @user = user
  end

  alias :read_attribute_for_serialization :send

  def serializable_hash
    {
      id: id,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      session_token: session_token,
    }
  end

  def id
    @blob_bucket
  end

  def access_key_id
    session.credentials[:access_key_id]
  end

  def secret_access_key
    session.credentials[:secret_access_key]
  end

  def session_token
    session.credentials[:session_token]
  end

  private

  def session
    @session ||= AWS::STS.new(
      access_key_id: @user.access_key_id,
      secret_access_key: @user.secret_access_key
    ).new_session(duration: 3600)
  end
end
