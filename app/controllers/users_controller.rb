class UsersController < ApplicationController
  respond_to :json

  def sign_in
    user_params = params[:user]
    user = User.where(email: user_params[:email].downcase).first.try(:authenticate, user_params[:password])
    if user
      respond_with user
    else
      render nothing: true, status: 401
    end
  end
end
