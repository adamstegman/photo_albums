module Authentication
  def current_user
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    if token
      User.where(email: options[:user_email], token: token).first
    end
  end

  def ensure_authorization
    unless current_user
      render nothing: true, status: 401
    end
  end
end
