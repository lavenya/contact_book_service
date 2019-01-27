# frozen_string_literal: true

module ParamsHelper
  def user_creation_params
    password = Faker::Lorem.characters(10)
    { name:  Faker::Name.name,
      email: Faker::Internet.email,
      password: password, password_confirmation:  password }
  end

  def invalid_password_params
    { name:  Faker::Name.name,
      email: Faker::Internet.email,
      password: Faker::Lorem.characters(10),
      password_confirmation: Faker::Lorem.characters(10) }
  end

  def user_updation_params
    { name:  Faker::Name.name }
  end

  def contact_creation_params
    { name:  Faker::Name.name,
      email: Faker::Internet.email }
  end

  def contact_updation_params
    { name:  Faker::Name.name,
      email: Faker::Internet.email }
  end

  def contact_search_params(search_query, page)
    { page: page, query: search_query }
  end
end
