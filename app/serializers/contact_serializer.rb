# frozen_string_literal: true

class ContactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :user_id
end
