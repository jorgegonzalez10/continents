class Api::V1::ContinentsController < ApplicationController
  before_action :set_continent, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]

  def index
    @continents = Continent.all
    render json: serialized(@continents, ContinentSerializer), status: 200
  end

  def show
    render json: serialized(@continent, ContinentSerializer), status: 200
  end

  def create
    @continent = current_user.continents.build(continent_params)
    if @continent.save!
      render json: serialized(@continent, ContinentSerializer), status: 201
    else
      render json: @continent.errors.full_messages
    end
  end

  def update
    if @continent = Continent.update(continent_params)
      render json: serialized(@continent, ContinentSerializer), status: 204
    else
      render json: @continent.errors.full_messages
    end
  end

  def destroy
    @continent = Continent.destroy
    render json: {message:"album deleted"}, status: 303
  end

  private

  def continent_params
    params.require(:continent).permit(:name, :user_id, :public)
  end

  def set_continent
    @continent = Continent.find(params[:id])
  end
end
