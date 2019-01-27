# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate, only: :create
  before_action :select_user, only: [:update, :destroy]

  def create
    user = User.create(creation_params)
    render_user_json(user)
  end

  def update
    @current_user.update(updation_params)
    render_user_json(@current_user)
  end

  def destroy
    @current_user.destroy
    render_user_json(@current_user)
  end

  private

  def creation_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def select_user
    user = User.where(id: params[:id]).first
    return render status: :not_found, json: nil if user.blank?
    render status: :forbidden, json: nil if user.id != @current_user.id
  end

  def updation_params
    params.permit(:name)
  end

  def error_message(object)
    Error.new(object.errors).messages
  end

  def render_user_json(user)
    return render_error(user) if user.errors.present?

    render json: UserSerializer.new(user).serializable_hash
  end

  def render_error(object)
    render status: 300, json: { errors: error_message(object) }
  end
end
