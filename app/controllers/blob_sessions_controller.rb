class BlobSessionsController < ApplicationController
  include Authentication

  respond_to :json

  before_action :ensure_authorization, except: [:sign_in]

  def show
    blob_session = BlobSession.new(current_user.blob_bucket, current_user)
    render json: {'blob_session' => BlobSessionSerializer.new(blob_session).as_json}
  end
end
