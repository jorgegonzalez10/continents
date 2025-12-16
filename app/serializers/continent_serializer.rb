class ContinentSerializer
  include JSONAPI::Serializer
  attributes :name, :id, :public
  belongs_to :user
  has_many :continent_images
end
