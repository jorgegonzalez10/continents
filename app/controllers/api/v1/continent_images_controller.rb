class Api::V1::ContinentImagesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_continent_image, only: %i[destroy]
  before_action :authorize_continent_owner!, only: %i[create]
  before_action :authorize_image_owner!, only: %i[destroy]

   def index
    if current_user
      @continent_images = ContinentImage.joins(:continent)
                                      .where( continents: {user: current_user}).or(ContinentImage.joins(:continent)
                                      .where(is_public: true, continents: {is_public: true}))
    else
      @continent_images = ContinentImage.joins(:continent)
                                      .where(is_public: true, continents: {is_public: true})
    end
      render json: serialized(@continent_images, ContinentImageSerializer), status: :ok
  end

  def create
    @continent = Continent.find(continent_image_params[:continent_id])

    @continent_image = @continent.continent_images.build(continent_image_params.except(:continent_id))

    if @continent_image.save
      render json: serialized(@continent_image, ContinentImageSerializer), status: :created
    else
      render json: { errors: @continent_image.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @continent_image.destroy
    render json: { message: "Photo deleted" }, status: :ok
  end

  private

  def continent_image_params
    params.require(:continent_image).permit(:name, :continent_id, :is_public, :photo)
  end

  def set_continent_image
    @continent_image = ContinentImage.find(params[:id])
  end

  def authorize_continent_owner!
    continent = Continent.find(continent_image_params[:continent_id])
    unless continent.user_id == current_user.id
      render json: { error: "Not authorized to add images to this continent" }, status: :forbidden
    end
  end

  def authorize_image_owner!
    unless @continent_image.continent.user_id == current_user.id
      render json: { error: "Not authorized to delete this image" }, status: :forbidden
    end
  end
end
