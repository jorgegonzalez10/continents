class ContinentImageSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers
  attribute :photo_url do |object|
    if object.photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.photo, only_path: false)
    end
  end
  attributes :name, :public, :id
  belongs_to :continent
end
