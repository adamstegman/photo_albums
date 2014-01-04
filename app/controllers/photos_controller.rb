class PhotosController < ApplicationController
  respond_to :json

  def index
    respond_with Photo.where(id: params[:ids])
  end

  def show
    respond_with Photo.find(params[:id])
  end
end
