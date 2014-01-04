class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :photos, embed: :ids
end
