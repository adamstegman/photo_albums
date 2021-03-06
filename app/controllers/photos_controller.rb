class PhotosController < ApplicationController
  include Authentication

  respond_to :json

  before_action :ensure_authorization

  def index
    photos = Photo.for_user(current_user).where(id: params[:ids])
    render json: PhotosSessionsSerializer.new(photos).as_json
  end

  def show
    photo = Photo.for_user(current_user).find(params[:id])
    render json: PhotoSessionSerializer.new(photo).as_json
  end
end
