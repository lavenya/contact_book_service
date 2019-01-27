# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :select_user, only: [:index, :show, :create, :update, :destroy, :search] # remove after adding current_user
  before_action :render_empty_result, only: :search, if: :small_query?
  before_action :select_contact, only: [:update, :destroy, :show]

  def index
    render json: ContactSerializer.new(@user.contacts).serializable_hash
  end

  def show
    render json: @contact
  end

  def create
    contact = @user.contacts.create(contact_params)
    render_contact_json(contact)
  end

  def update
    @contact.update(contact_params)
    render_contact_json(@contact)
  end

  def destroy
    @contact.destroy
    render_contact_json(@contact)
  end

  def search
    contacts = Contact.es_search_with_pagination(params[:query], @user.id, params[:page])
    render json: ContactSerializer.new(contacts).serializable_hash
  end

  private

  def render_empty_result
    render json: ContactSerializer.new([]).serializable_hash
  end

  def small_query?
    params[:query].length < 2
  end

  def render_contact_json(contact)
    return render_error(contact) if contact.errors.present?

    render json: ContactSerializer.new(contact).serializable_hash
  end

  def render_error(object)
    render json: { status: 300, errors: error_message(object) }
  end

  def error_message(object)
    Error.new(object.errors).messages
  end

  def contact_params
    params.permit(:name, :email)
  end

  def select_user
    @user = User.find(params[:user_id]) # change to current user
  end

  def select_contact
    @contact = @user.contacts.where(id: params[:id]).first
    render status: :not_found, json: nil if @contact.blank?
  end
end
