class AlbumsController < ApplicationController
  respond_to :json

  def inbox
    respond_with Albums::Inbox.new, serializer: AlbumSerializer
  end
end
