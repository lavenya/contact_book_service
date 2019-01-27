class ContactSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :user_id
end
