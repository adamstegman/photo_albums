class UsersController < ApplicationController
  respond_to :json

  def sign_in
    user = User.where(email: params[:email].downcase).first.try(:authenticate, params[:password])
    if user
      respond_with user
    else
      render nothing: true, status: 401
    end
  end
end
