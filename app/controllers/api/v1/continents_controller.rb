class Api::V1::ContinentsController < ApplicationController
  before_action :set_continent, only: %i[show update destroy]
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :authorize_continent_owner!, only: %i[update destroy]

  def index
    if current_user
      @continents = Continent.where(is_public: true)
                            .or(Continent.where(user: current_user))
    else
      @continents = Continent.where(is_public: true)
    end

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
    if @continent.update(continent_params)
      render json: serialized(@continent, ContinentSerializer), status: 200
    else
      render json: @continent.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @continent.destroy
    render json: {message:"album deleted"}, status: 303
  end

  private

  def continent_params
    params.require(:continent).permit(:name, :user_id, :is_public)
  end

  def set_continent
    @continent = Continent.find(params[:id])
  end

  def authorize_continent_owner!
    unless @continent.user_id == current_user.id
      render json: { error: "Not authorized to modify this continent" }, status: :forbidden
    end
  end
end
