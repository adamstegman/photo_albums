class AlbumsController < ApplicationController
  include Authentication

  respond_to :json

  before_action :ensure_authorization

  def inbox
    respond_with Albums::Inbox.new(current_user), serializer: AlbumSerializer
  end
end
