module Authentication
  def ensure_authorization
    email = request.headers['auth-email']
    token = request.headers['auth-token']
    unless User.where(email: email, token: token).exists?
      render nothing: true, status: 401
    end
  end
end
