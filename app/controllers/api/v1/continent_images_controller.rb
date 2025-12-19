class Api::V1::ContinentImagesController < ApplicationController
   def index
    @continent_images = ContinentImage.all
    render json: serialized(continent_images, ContinentImageSerializer), status: :ok
  end

  def create
    @continent = Continent.find(continent_image_params[:continent_id])

    @continent_image = continent.continent_images.build(continent_image_params.except(:continent_id))

    if continent_image.save
      render json: serialized(continent_image, ContinentImageSerializer), status: :created
    else
      render json: { errors: continent_image.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @continent_image = ContinentImage.find(params[:id])
    @continent_image.destroy

    render json: { message: "Photo deleted" }, status: :ok
  end

  private

  def continent_image_params
    params.require(:continent_image).permit(:name, :continent_id, :is_public, :photo)
  end
end
