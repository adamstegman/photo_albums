module Authentication
  def current_user
    email = request.headers['auth-email']
    token = request.headers['auth-token']
    User.where(email: email, token: token).first
  end

  def ensure_authorization
    unless current_user
      render nothing: true, status: 401
    end
  end
end
