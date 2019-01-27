# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :render_empty_result, only: :search, if: :small_query?
  before_action :select_contact, only: [:update, :destroy, :show]

  def index
    render json: ContactSerializer.new(@current_user.contacts).serializable_hash
  end

  def show
    render json: ContactSerializer.new(@contact).serializable_hash
  end

  def create
    contact = @current_user.contacts.create(contact_params)
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
    contacts = Contact.es_search_with_pagination(params[:query], @current_user.id, params[:page])
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
    render status: 300, json: { errors: error_message(object) }
  end

  def error_message(object)
    ::ContactBookErrors::Error.new(object.errors).messages
  end

  def contact_params
    params.permit(:name, :email)
  end

  def select_contact
    @contact = @current_user.contacts.where(id: params[:id]).first
    render status: :not_found, json: nil if @contact.blank?
  end
end
