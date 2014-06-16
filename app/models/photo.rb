class Photo < ActiveRecord::Base
  belongs_to :user

  scope :for_user, -> (user) { where(user_id: user.id) }

  def album
    Albums::Inbox.new(nil)
  end
end
