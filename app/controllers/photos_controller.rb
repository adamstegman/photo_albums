class PhotosController < ApplicationController
  include Authentication

  respond_to :json

  before_action :ensure_authorization

  def index
    respond_with Photo.for_user(current_user).where(id: params[:ids])
  end

  def show
    respond_with Photo.for_user(current_user).find(params[:id])
  end
end
