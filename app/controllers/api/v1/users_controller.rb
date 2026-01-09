class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authenticate_user!, except: [:create]
  before_action :authorize_user!, only: %i[show update destroy]

  def index
    # Solo permite ver todos los usuarios si está autenticado (podrías querer restringir más esto)
    @users = User.all
    render json: serialized(@users, UserSerializer), status: 200
  end

  def show
    render json: serialized(@user, UserSerializer), status: 200
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: serialized(@user, UserSerializer), status: :created
    else
      render json: {message: "Error al crear el usuario" }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: serialized(@user, UserSerializer), status: 201
    else
      render json: { message: "Error al actualizar el usuario" }, status: 400
    end
  end

  def destroy
    @user.destroy
      render json: { message: "Usuario eliminado correctamente" }, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user!
    unless @user.id == current_user.id
      render json: { error: "Not authorized to access this user" }, status: :forbidden
    end
  end

end
