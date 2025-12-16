class UserSerializer
  include JSONAPI::Serializer
  attributes :email
  has_many :continents
  has_many :continent_images, through: :continents
end
